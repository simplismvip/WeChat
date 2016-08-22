//
//  RecorderTool.m
//  Reco--录音
//
//  Created by lanouhn on 16/3/4.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "RecorderTool.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface RecorderTool ()<AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioRecorder *recoder;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIViewController *superVC;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) AVAudioPlayer *play;
@end

@implementation RecorderTool

// 配置录音机
- (BOOL)initWithFileRecorderWithName:(NSString *)path
{
//    NSMutableDictionary *recordSet = [[NSMutableDictionary alloc] init];
//    [recordSet setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
//    [recordSet setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
//    [recordSet setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
//    [recordSet setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
//    [recordSet setValue:[NSNumber numberWithInt:AVAudioQualityMedium] forKey:AVEncoderAudioQualityKey];
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];//
    [recordSetting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];//采样率
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];//声音通道
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];//音频质量
    
    // 第二次
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [session setActive:YES error:nil];

    // 设置播放器为扬声器模式
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    NSError *audioError = nil;
    BOOL success = [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&audioError];
    if(!success){
        
        // NSLog(@"error doing outputaudioportoverride - %@", [audioError localizedDescription]);
    }
    
    // 判断麦克风是否开启
    if ([self canRecord:session]) {
        
        NSURL *url = [NSURL fileURLWithPath:path];
        self.url = url;
        
        // 初始化录音类
        NSError *error;
        self.recoder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
        _recoder.delegate = self;
        _recoder.meteringEnabled = YES;
        
        if ([_recoder prepareToRecord]) {
            
            // 添加显示的动画
            CGFloat width = (100.0/414.0) *self.superVC.view.bounds.size.width;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
            imageView.center = CGPointMake(self.superVC.view.bounds.size.width/2, self.superVC.view.bounds.size.height/2);
            [self.superVC.view addSubview:imageView];
            self.imageView = imageView;
            
            // 设置定时检查, 检查音量大小
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
            NSLog(@"开始录音");
        }
        
        return [_recoder record];
    }else{
        
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"net.pictoshare.pageshare.opaudiomangertool.alert.title", "") message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *aa = [UIAlertAction actionWithTitle:NSLocalizedString(@"net.pictoshare.pageshare.dialog.button.ok", "") style:(UIAlertActionStyleDefault) handler:nil];
        [ac addAction:aa];
        [self.superVC presentViewController:ac animated:YES completion:nil];
        return NO;
    }
}

// 实时检查当前音量
- (void)detectionVoice
{
    // 刷新音量数据
    [self.recoder updateMeters];
    double volume = pow(10, (0.05 * [_recoder peakPowerForChannel:0]));
    
    if (volume <= 0.16) {
        [self.imageView setImage:[UIImage imageNamed:@"recording_1"]];
    } else if (0.16 < volume <= 0.32) {
        [self.imageView setImage:[UIImage imageNamed:@"recording_2"]];
    } else if (0.32 < volume <= 0.48) {
        [self.imageView setImage:[UIImage imageNamed:@"recording_3"]];
    } else if (0.48 < volume <= 0.64) {
        [self.imageView setImage:[UIImage imageNamed:@"recording_4"]];
    } else if (0.64 < volume <= 0.85) {
        [self.imageView setImage:[UIImage imageNamed:@"recording_5"]];
    } else {
        [self.imageView setImage:[UIImage imageNamed:@"recording_6"]];
    }
}

// 检查录音麦克风是否开启
- (BOOL)canRecord:(AVAudioSession *)audioSession
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]){
            
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                
                bCanRecord=granted;
            }];
        }
    }
    
    return  bCanRecord;
}

// 设置superVC
- (void)setDelegateRec:(id<RecorderToolDelegate>)delegateRec
{
    _delegateRec = delegateRec;
    if ([delegateRec isKindOfClass:[UIView class]]) {
        
        UIView *view = (UIView *)delegateRec;
        self.superVC = [self findViewController:view];
        
    }else if ([delegateRec isKindOfClass:[UIViewController class]]) {
        
        self.superVC = (UIViewController *)delegateRec;
    }
}

// 通过View获取控制器方法
- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

#pragma mark -- 开始播放
- (void)playerRecordByPath:(NSString *)path{
    
    [_play stop];
    _play = nil;
    
    // 后台播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSError *err = nil;
    self.play = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    _play.volume = 1.0;
    [_play prepareToPlay];
    [_play play];
}

#pragma mark -- 删除录音
- (void)playDragExit {
    [_recoder stop];
    
    BOOL isSuccess = [_recoder deleteRecording];
    [_timer invalidate];
    NSLog(@"%@", isSuccess ? @"删除成功" :@"删除失败");
}

#pragma mark -- 开始录音
- (void)playEventTouchDown {
    
    BOOL isSec = [self startRecordPage:10 path:NSHomeDirectory()];
    
    // 按下开始录音
    if(isSec){
        
        NSLog(@"录音成功");
    }
}

#pragma mark -- 结束录音
- (void)playTouchUpInside {
    
    // 松开时结束录音
    double cTime = _recoder.currentTime;
    if (cTime > 1.0) {
        
        NSLog(@"录音成功");
        [_recoder stop];
        
        // 停止录音后拿到音频资源转化成base64字符串
        NSString *base64Str = [self.class transformToBase64:self.url type:@"voice"];
        
        // 返回字符串
        if ([self.delegateRec respondsToSelector:@selector(getBase64Str:)]) {
            
            [self.delegateRec getBase64Str:base64Str];
        }
        
        // NSString *path = [self.class transfromByBase64:base64Str];
        // NSLog(@"base64Str = %@", path);
        
    }else {
        
        [_recoder stop];
        [_recoder deleteRecording];
        NSLog(@"%@", [_recoder deleteRecording] ? @"删除录音成功" :@"删除录音失败");
    }
    
    // 结束录音
    [self.imageView removeFromSuperview];
    [_timer invalidate];
    _timer = nil;
}

// 开始录音
- (BOOL)startRecordPage:(NSInteger)page path:(NSString *)path
{
    // 设置录音状态为YES
    // self.isRecoder = YES;
    NSArray *array = [self getFilesByKey:[NSString stringWithFormat:@"%ld", page] path:path];
    NSMutableArray *keyArr = [NSMutableArray array];
    for (NSString *str in array) {
        NSArray *strArr = [str componentsSeparatedByString:@"_"];
        [keyArr addObject:strArr[2]];
    }
    
    NSNumber *max = [keyArr valueForKeyPath:@"@max.floatValue"];
    self.pageNum = max.integerValue+1;
    
    // 返回生成的路径
    NSString *filePath = [self returnNameByNumber1:page number2:self.pageNum path:path];
    
    // 返回录音是否成功
    return [self initWithFileRecorderWithName:filePath];
}

#pragma mark -- 把页数作为关键字获取文件名
- (NSMutableArray *)getFilesByKey:(NSString *)key path:(NSString *)path
{
    NSFileManager *manger = [NSFileManager defaultManager];
    NSMutableArray *keyArr   = [NSMutableArray array];
    BOOL dir        = NO;
    BOOL exist       = [manger fileExistsAtPath:path isDirectory:&dir];
    
    // 文件不存在
    if (!exist) return 0;
    
    // YES代表文件夹 NO代表文件
    if (dir) {
        
        // int count = 0;
        NSArray *array = [manger contentsOfDirectoryAtPath:path error:nil];
        
        // 遍历数组
        for (NSString *fileName in array) {
            
            // 1> 将数组内的字符串以"_"分割
            if ([fileName pathExtension].length > 0) {
                
                NSArray *striArray = [fileName componentsSeparatedByString:@"_"];
                
                // 2> 分割字符串获得数组如果数量大于2取得striArray[1]和key比较
                if (striArray.count >= 2) {
                    
                    // 3> 如果两者相等, 添加数组返回数组
                    if ([striArray[1] isEqualToString:key]) {
                        
                        [keyArr addObject:fileName];
                    }
                }
            }
        }
    }
    return keyArr;
}

#pragma mark -- 根据默认路径返回生成路径
- (NSString *)returnNameByNumber1:(NSInteger)number1 number2:(NSInteger)number2 path:(NSString *)path
{
    // 生成时间戳
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *fileName = [NSString stringWithFormat:@"%lld", recordTime];
    
    // 第几个文件的第几页的录
    NSString *name = [NSString stringWithFormat:@"V_%ld_%ld", number1, number2];
    
    // 完整的文件名字
    NSString *fullName = [NSString stringWithFormat:@"%@_%@", name, fileName];
    
    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",fullName]];
}

// 返回当前时间
+ (NSString *)returnDate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"YYYYMMddHHmmss"];
    NSString *dateString = [formate stringFromDate:date];
    return dateString;
}

#pragma mark -- 将文件转成base64并发送
+ (NSString *)transformToBase64:(NSURL *)sendStr type:(NSString *)type
{
    if ([type isEqualToString:@"image"]) {
        
        UIImage *image = [UIImage imageWithContentsOfFile:sendStr.absoluteString];
        NSData *data = UIImagePNGRepresentation(image);
        NSString *base64Str = [data base64EncodedStringWithOptions:0];
        NSString *typeString = [NSString stringWithFormat:@"%@-%@", type, base64Str];
        return typeString;
        
    }else if([type isEqualToString:@"voice"]){
    
        NSData *data = [NSData dataWithContentsOfURL:sendStr];
        NSString *base64Str = [data base64EncodedStringWithOptions:0];
        NSString *typeString = [NSString stringWithFormat:@"%@-%@", type, base64Str];
        return typeString;
        
    }else{
        
        return nil;
    }
}

#pragma mark -- 将base64转成音频文件并返回地址
+ (NSString *)transfromByBase64:(NSString *)getString
{
    NSString *date = [self returnDate];
    NSArray *array = [getString componentsSeparatedByString:@"-"];
    NSString *type = array.firstObject;
    NSString *base64 = array.lastObject;
    
    if ([type isEqualToString:@"image"]) {
        
        NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        filePath = [filePath stringByAppendingFormat:@"/%@.jpg", date];
        [data writeToFile:filePath atomically:YES];
        return filePath;
        
    }else if([type isEqualToString:@"voice"]){
        
        NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        filePath = [filePath stringByAppendingFormat:@"/%@.caf", date];
        [data writeToFile:filePath atomically:YES];
        return filePath;
        
    }else{
        
        return nil;
    }
}


@end
