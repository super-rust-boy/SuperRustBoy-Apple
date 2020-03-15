//
//  Speaker.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 14/03/2020.
//  Copyright © 2020 Sean Inge Asbjørnsen. All rights reserved.
//

import AudioToolbox

internal protocol SpeakerDelegate: AnyObject {
    func speaker(_ speaker: Speaker, requestsData data: inout [Float])
}

internal final class Speaker {

    internal var volume: Float {
        get {
            var volume: Float = 0
            AudioQueueGetParameter(audioQueue, kAudioQueueParam_Volume, &volume)
            return volume
        }
        set {
            AudioQueueSetParameter(audioQueue, kAudioQueueParam_Volume, newValue)
        }
    }

    internal weak var delegate: SpeakerDelegate?

    internal init?(sampleRate: Float64) {

        bufferSize = Int(sampleRate / 60)

        var desc = AudioStreamBasicDescription(
            mSampleRate:        sampleRate,
            mFormatID:          kAudioFormatLinearPCM,
            mFormatFlags:       kAudioFormatFlagIsFloat,
            mBytesPerPacket:    8,
            mFramesPerPacket:   1,
            mBytesPerFrame:     8,
            mChannelsPerFrame:  2,
            mBitsPerChannel:    32,
            mReserved:          0
        )

        let createError = AudioQueueNewOutput(&desc, Self.audioQueueOutputCallback, bridge(obj: self), nil, nil, 0, &audioQueue)

        guard createError == noErr else {
            assertionFailure("Error creating audio queue")
            return nil
        }

        let isRunningListenerError = AudioQueueAddPropertyListener(audioQueue, kAudioQueueProperty_IsRunning, Self.startedListener, bridge(obj: self))

        guard isRunningListenerError == noErr else {
            assertionFailure("Error adding listener to audio queue")
            return nil
        }

        for _ in 0..<Self.numberOfBuffers {
            var audioQueueBuffer: AudioQueueBufferRef?
            let error = AudioQueueAllocateBuffer(audioQueue, UInt32(bufferSize), &audioQueueBuffer)

            guard error == noErr else {
                assertionFailure("Failed to create buffer")
                return nil
            }

            guard let buffer = audioQueueBuffer else {
                assertionFailure("Buffer is nil")
                return nil
            }

            buffers.append(buffer)
        }

        let startError = AudioQueueStart(audioQueue, nil)

        guard startError == noErr else {
            assertionFailure("Failed to start")
            return nil
        }
    }

    deinit {
        let error = AudioQueueDispose(audioQueue, true)
        assert(error == noErr, "Error disposing audio queue")
    }

    private var audioQueue: AudioQueueRef!
    private var buffers: [AudioQueueBufferRef] = []

    private let bufferSize: Int

    private static let numberOfBuffers = 300

    private static let startedListener: AudioQueuePropertyListenerProc = { userData, audioQueue, propertyID in

        guard propertyID == kAudioQueueProperty_IsRunning else {
            assertionFailure("Wrong property")
            return
        }

        var isRunning: UInt32 = 0
        var size = UInt32(MemoryLayout.size(ofValue: UInt32.self))

        let error = AudioQueueGetProperty(audioQueue, kAudioQueueProperty_IsRunning, &isRunning, &size)

        guard error == noErr else {
            assertionFailure("Failed to get prop isRunning")
            return
        }

        guard let userData = userData else {
            assertionFailure("UserData is nil")
            return
        }

        let speaker: Speaker = bridge(ptr: userData)

        if isRunning > 0 {
            speaker.buffers.forEach { buffer in
                Speaker.audioQueueOutputCallback(userData, audioQueue, buffer)
            }
        }
    }

    private static let audioQueueOutputCallback: AudioQueueOutputCallback = { userData, audioQueue, buffer in

        guard let userData = userData else {
            assertionFailure("UserData is nil")
            return
        }

        let speaker: Speaker = bridge(ptr: userData)

        // Fill buffer with silence
        memset(buffer.pointee.mAudioData, 0, speaker.bufferSize)
        buffer.pointee.mAudioDataByteSize = UInt32(speaker.bufferSize)

        if let delegate = speaker.delegate {

            var floatBuffer = [Float](repeating: 0, count: speaker.bufferSize / 4)

            speaker.delegate?.speaker(speaker, requestsData: &floatBuffer)

//            print("FloatBuffer: \(floatBuffer)")
//            print()

            memcpy(buffer.pointee.mAudioData, floatBuffer, speaker.bufferSize)
        }

        let error = AudioQueueEnqueueBuffer(audioQueue, buffer, 0, nil)

        guard error == noErr else {
            assertionFailure("Failed to queue buffer")
            return
        }
    }
}


