//
//  SettingProfileTable.m
//  MorningCall
//
//  Created by Tian Tian on 2/13/15.
//  Copyright (c) 2015 goexcite.today. All rights reserved.
//

#import "SettingProfileTable.h"
#import "LayoutExtension.h"
#import "Brain.h"
#import "ConfirmItemInputView.h"

@interface SettingProfileTable ()
@end

@implementation SettingProfileTable

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Account";
    
    [self adjustCellLayout];
    
    [self generateQRCodeImg];
    
    _idLabel.text = [Me alive].privateInfo.uniqueName;
}

- (void)adjustCellLayout{
    _idLabel.center = CGPointMake(self.tableView.frame.size.width-_idLabel.frame.size.width/2-self.tableViewCellContentRightIndentWithIndicator, 30);
//    _emailLabel.center = CGPointMake(self.tableView.frame.size.width-_emailLabel.frame.size.width/2-self.tableViewCellContentRightIndentWithIndicator, 30);
    _emailLabel.frame = CGRectMake(60, _emailLabel.frame.origin.y, self.tableView.frame.size.width-60-self.tableViewCellContentRightIndentWithIndicator, 30);
    _myQRCodeImg.center = CGPointMake(self.tableView.frame.size.width-_myQRCodeImg.frame.size.width/2-self.tableViewCellContentRightIndentWithIndicator, 30);
}

- (void)generateQRCodeImg{
    CIFilter *ciFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [ciFilter setDefaults];
    
    // 格納する文字列をNSData形式（UTF-8でエンコード）で用意して設定
    NSString *qrString = [Me alive].privateInfo.userId;
    NSData *data = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    [ciFilter setValue:data forKey:@"inputMessage"];
    
    // 誤り訂正レベルを「L（低い）」に設定
    [ciFilter setValue:@"L" forKey:@"inputCorrectionLevel"];
    
    // Core Imageコンテキストを取得したらCGImage→UIImageと変換して描画
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgimg =
    [ciContext createCGImage:[ciFilter outputImage]
                    fromRect:[[ciFilter outputImage] extent]];
    UIImage *image = [UIImage imageWithCGImage:cgimg scale:1.0f
                                   orientation:UIImageOrientationUp];
    CGImageRelease(cgimg);
    
    // その１：UIImageを最近傍法を適用しつつリサイズする
    UIGraphicsBeginImageContext(CGSizeMake(300, 300));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone); //←補間方法の指定
    [image drawInRect:CGRectMake(0, 0, 300, 300)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // その２：UIImageViewの描画方法を最近傍法に切り替える
    _myQRCodeImg.layer.magnificationFilter = kCAFilterNearest; //←補間方法の指定
    _myQRCodeImg.contentMode = UIViewContentModeScaleAspectFit;
    
    _myQRCodeImg.image = image;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        return _qrCodeCell;
//    }
//    else if (indexPath.section == 1){
//        if (indexPath.row==0) {
//            _idCell.accessoryType = _idLabel.text.length>0 ?UITableViewCellAccessoryNone:UITableViewCellAccessoryDisclosureIndicator;
//            return _idCell;
//        }
//        else if (indexPath.row == 1){
//            _emailCell.accessoryType = _emailLabel.text.length>0 ?UITableViewCellAccessoryNone:UITableViewCellAccessoryDisclosureIndicator;
//            return _emailCell;
//        }
//    }
//    
//    return nil;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UIViewController *detailQR = [[UIViewController alloc] init];
        detailQR.title = @"QR Code";
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-20, self.view.bounds.size.width-20)];
        imageView.center = detailQR.view.center;
        imageView.image = _myQRCodeImg.image;
        [detailQR.view addSubview:imageView];
        detailQR.view.backgroundColor = self.mc_BackgroundGreen;
        [self.navigationController pushViewController:detailQR animated:YES];
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            ConfirmItemInputView *confirmInvitation;
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
                confirmInvitation = [[UIStoryboard storyboardWithName:@"iPhoneMain" bundle:nil] instantiateViewControllerWithIdentifier:@"ConfirmItemInputView"];
            }else{
                confirmInvitation = [[UIStoryboard storyboardWithName:@"iPadMain" bundle:nil] instantiateViewControllerWithIdentifier:@"ConfirmItemInputView"];
            }
            confirmInvitation.confirmTitle = @"Please Enter Your User ID :";
            confirmInvitation.inputPlaceHolder = @"User ID";
            confirmInvitation.inputContent = _idLabel.text;
            [self.navigationController pushViewController:confirmInvitation animated:YES];
        }
    }
}


@end
