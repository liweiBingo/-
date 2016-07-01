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
    sender.selected  = !sender.selected;
    _isFontCamera = !_isFontCamera;
    [self setupCamera];
}

//获取图片
- (void)getPhoto{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    [_captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
       
       CFDictionaryRef exifAttachments = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyExifDictionary, nil);
        if (exifAttachments) {
//
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *t_image = [[UIImage alloc] initWithData:imageData];
        _photo = [[UIImage alloc]initWithCGImage:t_image.CGImage scale:1.5 orientation:UIImageOrientationRight];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:_previewLayer.frame];
        [_previewLayer removeFromSuperlayer];
        imageView.image = _photo;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.view addSubview:imageView];
        
        
    }];
    
}

// 切换闪光灯模式
- (void)switchFlashMode:(UIButton*)sender {
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (!captureDeviceClass) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您的设备没有拍照功能" delegate:nil cancelButtonTitle:NSLocalizedString(@"Sure", nil) otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSString *imgName = @"";
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if ([device hasFlash]) {
        if (device.flashMode == AVCaptureFlashModeOff) {
            device.flashMode = AVCaptureFlashModeOn;
            imgName = @"";
        } else if (device.flashMode == AVCaptureFlashModeOn) {
            device.flashMode = AVCaptureFlashModeAuto;
            imgName = @"";
        } else if (device.flashMode == AVCaptureFlashModeAuto) {
            device.flashMode = AVCaptureFlashModeOff;
            imgName = @"";
        }
        if (sender) {
            [sender setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您的设备没有闪光灯功能" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
    }
    [device unlockForConfiguration];
    
}
// 初始化相机

- (void)setupCamera{
    
    AVCaptureDevice *captureDevice = [self getVideoInputCamera:(_isFontCamera ? isFrontCamera : isBackCamera)];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    if ([self.session canAddInput:deviceInput]){
        [_session addInput:deviceInput];
    }
    
    // 预览视图(取景器)
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer *preLayer = [[self view] layer];
    [preLayer setMasksToBounds:YES];
    [_previewLayer setFrame:CGRectMake(10, 100, 300, 300)];
    [preLayer insertSublayer:_previewLayer atIndex:0];
    [_session startRunning];
    
    // 创建一个输出设备,并将它添加到会话
    _captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    _captureOutput.outputSettings = outputSettings;
    [_session addOutput:_captureOutput];
}
#pragma mark VideoCapture
- (AVCaptureDevice *)getVideoInputCamera:(cameraType )cameraType{
    
    //获取(后置/前置)摄像头设备
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in cameras){
        switch (cameraType) {
            case isFrontCamera:
                if (device.position == AVCaptureDevicePositionFront)
                    return device;
                break;
            case isBackCamera:
                if (device.position == AVCaptureDevicePositionBack)
                    return device;
                break;
            default:
                break;
        }
    }
    return  [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end














