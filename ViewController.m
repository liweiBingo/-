//
//  ViewController.m
//  照相机
//
//  Created by 李伟 on 16/7/1.
//  Copyright © 2016年 李伟. All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>



typedef enum {
    isFrontCamera = 0,
    isBackCamera
    
}cameraType;

typedef enum {
    AutoFlash = 0,
    CloseFlash,
    OpenFlash
    
}flashModel;



@interface ViewController ()<AVCaptureAudioDataOutputSampleBufferDelegate,UIImagePickerControllerDelegate>{
    UIImage *_photo;
    BOOL _isFontCamera;
}

@property (strong , nonatomic) AVCaptureSession   *session;//捕获会话
@property (strong , nonatomic) AVCaptureStillImageOutput   *captureOutput; //输出设备
@property (strong , nonatomic) AVCaptureVideoPreviewLayer  *previewLayer; //取景器

@end

@implementation ViewController

- (AVCaptureSession *)session{
    if (_session == nil) {
        _session = [[AVCaptureSession alloc]init];
    }
    return _session;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark -------action
//拍照
- (void)capture{
    if (![self.session isRunning]) {
        
    }else{
        [_session stopRunning];
    }
    
}
//切换摄像头
- (void)switchCamera:(UIButton *)sender{
    
    [self.session stopRunning];
    
    [_previewLayer removeFromSuperlayer];
    
    sender.selected  = !_isFontCamera;
    [self setupCamera];
}

//获取图片
- (void)getPhoto{
    
}

// 切换闪光灯模式
- (void)switchFlashMode:(UIButton*)sender {
    
    
}
// 初始化相机

- (void)setupCamera{
    
    
}
#pragma mark VideoCapture
- (AVCaptureDevice *)getVideoInputCamera:(cameraType )cameraType{
    
    
    return  [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end














