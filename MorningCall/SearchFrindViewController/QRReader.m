//
//  QRReader.m
//  MorningCall
//
//  Created by Tian Tian on 2/24/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "QRReader.h"

#import <AVFoundation/AVFoundation.h>

@interface QRReader () <AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@end

@implementation QRReader

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"QR Reader";
    
    self.session = [[AVCaptureSession alloc] init];
    
    // Testing the VIN Scanner before I make it part of the library
    NSLog(@"Setting up the vin scanner");
    self.session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    if (input) {
        [self.session addInput:input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.session addOutput:output];
    
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    previewLayer.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view.layer addSublayer:previewLayer];
    
    [self.session startRunning];
    
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code]];
}

#pragma - Delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    // 認識されたメタデータは複数存在することもあるので、１つずつ調べる
    for (AVMetadataObject *data in metadataObjects) {
        
        // 一次元・二次元コード以外は無視する
        // ※人物顔の識別結果だった場合など
        if (![data isKindOfClass:[AVMetadataMachineReadableCodeObject class]])
            continue;
        
        // コード内の文字列を取得
        NSString *strValue =
        [(AVMetadataMachineReadableCodeObject *)data stringValue];
        
        // 何のタイプとして認識されたかを確認
        if ([data.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            [self addFriendshipWithUserId:strValue];
//            NSURL *url = [NSURL URLWithString:strValue];
            //            if ([[UIApplication sharedApplication] canOpenURL:url]) {
            //                [[UIApplication sharedApplication] openURL:url];
            //            }
        } else if([data.type isEqualToString:AVMetadataObjectTypeEAN13Code]) {
            
            // JANコード（標準タイプ）の場合、ISBNかどうかを調べて
            // ASINコードに変換し、対応するAmazonのページを開く
            long long value = strValue.longLongValue;
            NSInteger prefix = value / 10000000000;
            if (prefix == 978 || prefix == 979) { // ISBNかどうかをチェック
                long long isbn9 = (value % 10000000000) / 10;
                long long sum = 0, tmp_isbn = isbn9;
                for (int i=10; i>0 && tmp_isbn>0; i--) {
                    long long divisor = pow(10, i-2);
                    sum += (tmp_isbn / divisor) * i;
                    tmp_isbn %= divisor;
                }
                long long checkdigit = 11 - (sum % 11);
                
                // asinコードに変換
                NSString *asin =
                [NSString stringWithFormat:@"http://amazon.jp/dp/%lld%@",
                 isbn9,
                 (checkdigit == 10)?
                 @"X":
                 [NSString stringWithFormat:@"%lld", checkdigit%11]];
                NSLog(@"read asin : %@",asin);
                //                [[UIApplication sharedApplication]
                //                 openURL:[NSURL URLWithString:asin]]; // URLのオープン
            }
        }
    }
}

- (void)addFriendshipWithUserId:(NSString *)userId{
    NSLog(@"Add Friendship with  :%@",userId);
    [self.navigationController popViewControllerAnimated:YES];
}

@end

//self.session = [[AVCaptureSession alloc] init];
//AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//
//NSError *error = nil;
//AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
//                                                                    error:&error];
//if (input) {
//    [self.session addInput:input];
//} else {
//    NSLog(@"Error: %@", error);
//}
//
////        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
////        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
////        [self.session addOutput:output];
////        [self.session startRunning];
//
//AVCaptureMetadataOutput *metaOutput = [[AVCaptureMetadataOutput alloc] init];
//[metaOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
////                                         queue:dispatch_queue_create("myQueue.metadata", DISPATCH_QUEUE_SERIAL)];
//
//[self.session addOutput:metaOutput];
//
//AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
//
//// Display full screen
//previewLayer.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
//
//// Add the video preview layer to the view
//[self.view.layer addSublayer:previewLayer];
//
//[self.session startRunning];
//// アウトプットに追加後、識別したいコード（QRコード、JANコード標準タイプ）を指定
////   ※顔認識とコード認識の両方を同時に渡しても、どちらも正常に動作する
//NSLog(@"avaliable types : %@",metaOutput.availableMetadataObjectTypes);
//metaOutput.metadataObjectTypes =
//@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code];
