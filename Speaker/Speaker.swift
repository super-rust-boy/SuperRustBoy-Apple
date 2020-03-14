//
//  Speaker.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 14/03/2020.
//  Copyright © 2020 Sean Inge Asbjørnsen. All rights reserved.
//

import AudioToolbox

internal final class Speaker {

    internal var volume: Float {
        get {
            var volume: Float = 0
            AudioQueueGetParameter(audioqueue, kAudioQueueParam_Volume, &volume)
            return volume
        }
        set {
            AudioQueueSetParameter(audioqueue, kAudioQueueParam_Volume, newValue)
        }
    }

    internal init?() {

        var desc = AudioStreamBasicDescription(mSampleRate: 0, mFormatID: kAudioFormatLinearPCM, mFormatFlags: 0, mBytesPerPacket: 0, mFramesPerPacket: 0, mBytesPerFrame: 0, mChannelsPerFrame: 0, mBitsPerChannel: 0, mReserved: 0)

        let createError = AudioQueueNewOutput(&desc, Self.audioQueueOutputCallback, bridge(obj: self), nil, nil, 0, &audioqueue)

        guard createError == noErr else {
            assertionFailure("Error creating audio queue")
            return nil
        }

        let isRunningListenerError = AudioQueueAddPropertyListener(audioqueue, kAudioQueueProperty_IsRunning, Self.startedListener, bridge(obj: self))

        guard isRunningListenerError == noErr else {
            assertionFailure("Error adding listener to audio queue")
            return nil
        }

        for _ in 0..<Self.numberOfBuffers {
            var audioQueueBuffer: AudioQueueBufferRef?
            let error = AudioQueueAllocateBuffer(audioqueue, 0, &audioQueueBuffer)

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
    }

    deinit {
        let error = AudioQueueDispose(audioqueue, true)
        assert(error == noErr, "Error disposing audio queue")
    }

    private var audioqueue: AudioQueueRef!
    private var buffers: [AudioQueueBufferRef] = []

    private static let numberOfBuffers = 3

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

        let error = AudioQueueEnqueueBuffer(audioQueue, buffer, 0, nil)

        guard error == noErr else {
            assertionFailure("Failed to queue buffer")
            return
        }
    }
}


