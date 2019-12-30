//
//  ViewController.m
//  系统读文本demo
//
//  Created by 未思语 on 2019/12/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>



@interface ViewController ()<AVSpeechSynthesizerDelegate>
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UILabel *label;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 400, 100)];
    self.label.numberOfLines = 0;
    self.label.textColor = [UIColor redColor];
    self.label.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.label];
    
    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button1 addTarget:self action:@selector(startPlay:) forControlEvents:UIControlEventTouchUpInside];
    self.button1.backgroundColor = [UIColor redColor];
    [self.button1 setTitle:@"开始播放" forState:UIControlStateNormal];
    self.button1.frame = CGRectMake(100, 200, 100, 100);
    [self.view addSubview:self.button1];
    
    
    self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button2 addTarget:self action:@selector(endPlay:) forControlEvents:UIControlEventTouchUpInside];
    self.button2.backgroundColor = [UIColor purpleColor];
    [self.button2 setTitle:@"结束播放" forState:UIControlStateNormal];
    self.button2.frame = CGRectMake(100, 300, 100, 100);
    [self.view addSubview:self.button2];
    
    [self getTxtFileContent];
    // Do any additional setup after loading the view.
}
- (NSString *)getTxtFileContent {
    // 获取txt文件中的文本内容
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"txt"];
    NSString *text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return text;
}
- (void)startPlay:(UIButton *)sender {
    NSString *text = [self getTxtFileContent];
    [self readingContentText:text];
    
}
- (void)endPlay:(UIButton *)sender {
    
    if ([self.synthesizer isSpeaking]) {
        [self.synthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryWord];
    }
}
- (void)readingContentText:(NSString *)text {
    //1.初始化播音器
    if (!self.synthesizer) {
        self.synthesizer = [[AVSpeechSynthesizer alloc]init];
        self.synthesizer.delegate = self;
    }
    //2.将需要朗读的文本合成语音
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:text];
    
    /*
     avspeech支持的语言种类包括：
     "th-TH","pt-BR","sk-SK","fr-CA","ro-RO","no-NO","fi-FI","pl-PL","de-DE",
     "nl-NL","id-ID","tr-TR","it-IT","pt-PT","fr-FR","ru-RU","es-MX","zh-HK",
     中文(香港)粤语"sv-SE","hu-HU","zh-TW",中文(台湾)"es-ES","zh-CN",中文(普通话)
     "nl-BE","en-GB",英语(英国)"ar-SA","ko-KR","cs-CZ","en-ZA","en-AU","da-DK",
     "en-US",英语(美国)"en-IE","hi-IN","el-GR","ja-JP"
     */
    
    //3.播放中文
    AVSpeechSynthesisVoice *voiceLanguage = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utterance.voice = voiceLanguage;
 
    //4.语速0.0f - 1.0f
    utterance.rate = 0.5f;
    
    //5.播放音调 0.5f-2.0f
    utterance.pitchMultiplier = 1.0f;
    
    //6.播放下一句的时候有 0.2s 延迟时间
    utterance.postUtteranceDelay = 0.2f;
    
    //7.设置音量大小  0.0f-1.0f
    utterance.volume = 0.1f;
    
    //8.播放合成语音
    [self.synthesizer speakUtterance:utterance];
    
    //9.暂停播放合成语音
//    [self.synthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryWord];
    
    
}

#pragma mark - AVSpeechSynthesizerDelegate

// 开始播放
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance {
   NSLog(@"开始播放");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
   NSLog(@"完成播放");
   
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance {
   NSLog(@"暂停播放");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance {
   NSLog(@"恢复播放");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance {
   NSLog(@"取消播放");
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance {
   NSLog(@"将要播放某一段语音");
    self.label.text = utterance.speechString;
    
}

@end
