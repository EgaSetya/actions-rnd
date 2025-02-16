//
//  VoiceModeView.swift
//  Bythen
//
//  Created by edisurata on 14/09/24.
//

import SwiftUI

enum VoiceModeState {
    case hidden
    case startSpeaking
    case listening
    case generating
    case memoryUpdated
    case interrupt
    case uploading
    case uploadSuccess
    
    func getText() -> String {
        switch self {
        case .startSpeaking:
            return "Start Speaking"
        case .listening:
            return "Listening"
        case .generating:
            return "Generating"
        case .memoryUpdated:
            return "Updated memory"
        case .interrupt:
            return "Tap Byte to interrupt"
        default:
            return ""
        }
    }
    
    func getUploadingText(progress: Double) -> String {
        return "Uploading: \(Int(progress * 100))%..."
    }
    
    func getUploadSuccessText(fileName: String) -> String {
        return "Uploaded: \(fileName)"
    }
}

struct VoiceModeView: View {
    
    @Binding var voiceState: VoiceModeState
    @Binding var isMute: Bool
    var micAction: () -> Void
    var attachmentAction: () -> Void
    var chatmodeAction: () -> Void
    var interruptAction: () -> Void
    @Binding var voicePower: [Double]
    @Binding var uploadProgress: Double
    @Binding var uploadedFileName: String
    @State var isAnimateVoice: Bool = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            HStack {
                switch voiceState {
                case .uploadSuccess:
                    Image("upload-success-check")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.vertical, 6)
                case .memoryUpdated:
                    Image("task.fill")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundStyle(.byteBlack)
                        .frame(width: 20, height: 20)
                        .padding(.vertical, 6)
                default:
                    EmptyView()
                }
                
                Text(getVoiceText())
                .font(FontStyle.neueMontreal(size: 12))
                .padding(.vertical, 8)
                
                switch voiceState {
                case .uploadSuccess, .memoryUpdated:
                    EmptyView()
                case .uploading:
                    Button(action: {
                        interruptAction()
                    }, label: {
                        Image("stop-ico")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .padding(.leading, 3)
                            .padding(.vertical, 8)
                    })
                case .interrupt:
                    Button(action: {
                        interruptAction()
                    }, label: {
                        Image("stop-ico")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .padding(.leading, 3)
                            .padding(.vertical, 8)
                    })
                case .startSpeaking, .listening:
                    if isMute {
                        EmptyView()
                    } else {
                        VoiceView(
                            voicePower: $voicePower,
                            isAnimateLoading: false,
                            voiceSpeed: 2
                        )
                    }
                case .generating:
                    VoiceView(
                        voicePower: $voicePower,
                        isAnimateLoading: true,
                        voiceSpeed: 2
                    )
                default:
                    VoiceView(
                        voicePower: $voicePower,
                        isAnimateLoading: false,
                        voiceSpeed: 2
                    )
                }
            }
            .padding(.horizontal, 12)
            .background(
                Rectangle()
                    .fill(.clear)
                    .background(.ultraThinMaterial)
                    .opacity(0.8)
                    .blur(radius: 20, opaque: true)
                    .clipShape(RoundedRectangle(cornerRadius: 100))
            )
            
            HStack(spacing: 12) {
                Spacer()
                
                Button(action: {
                    attachmentAction()
                }, label: {
                    Image("attachment-clip")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.byteBlack)
                        .frame(width: 18, height: 18)
                        .padding(19)
                })
                .background(Circle().fill(.white, strokeBorder: .byteBlack, lineWidth: 1))
                .disabled(isDisableAttachment())
                
                Button(action: {
                    micAction()
                }, label: {
                    Image(isMute ? "mic-off.fill" : "mic.fill")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.white)
                        .frame(width: 22, height: 22)
                        .padding(17)
                })
                .background(Circle().fill(isMute ? .elmoRed500 : .sonicBlue700, strokeBorder: .byteBlack, lineWidth: 1))
                .disabled(isDisableMute())
                
                Button(action: {
                    chatmodeAction()
                }, label: {
                    Image("chat.fill")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.white)
                        .frame(width: 22, height: 22)
                        .padding(17)
                })
                .background(Circle().fill(.sonicBlue700, strokeBorder: .byteBlack, lineWidth: 1))
                
                Spacer()
            }
            .padding(.top, 16)
        }
        
    }
    
    private func getVoiceText() -> String {
        switch voiceState {
        case .uploading:
            return voiceState.getUploadingText(progress: uploadProgress)
        case .uploadSuccess:
            return voiceState.getUploadSuccessText(fileName: uploadedFileName)
        case .startSpeaking, .listening:
            if isMute {
                return "Microphone Muted"
            } else {
                return voiceState.getText()
            }
        default:
            return voiceState.getText()
        }
    }
    
    private func isDisableAttachment() -> Bool {
        switch voiceState {
        case .startSpeaking, .listening:
            return false
        default:
            return true
        }
    }
    
    private func isDisableMute() -> Bool {
        switch voiceState {
        case .startSpeaking, .listening:
            return false
        default:
            return true
        }
    }
}

#Preview {
    
    @State var voicePower = [0.0, 0.0, 0.0]
    @State var voiceState: VoiceModeState = .interrupt
    @State var progress: Double = 0.0
    @State var filename: String = ""
    @State var isMute: Bool = false
    
    return VStack {
        VoiceModeView(
            voiceState: $voiceState,
            isMute: $isMute,
            micAction: {
            
            }, attachmentAction: {
                
            }, chatmodeAction: {
                
            }, interruptAction: {
                
            },
            voicePower: $voicePower,
            uploadProgress: $progress,
            uploadedFileName: $filename
        )

    }.background(.green)
}
