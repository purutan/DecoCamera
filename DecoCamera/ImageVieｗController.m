//
//  ImageVieｗController.m
//  DecoCamera
//
//  Created by 藤田 優介 on 2016/02/07.
//  Copyright © 2016年 yusuke.fujita. All rights reserved.
//

#import "ImageViewController.h"
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>


@interface ImageViewController()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *grayButton;
@property (assign, nonatomic) BOOL isGray;
@property (nonatomic, retain) IBOutlet UISlider *sliderBrightness;
@property (weak, nonatomic) IBOutlet UIStepper *stepperScale;

- (IBAction)saveButtonAction:(id)sender;
- (IBAction)grayButtonAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)SliderChanged:(id)sender;
- (IBAction)stepperChange:(id)sender;

@end



@implementation ImageViewController
NSInteger grayFlag;



- (IBAction)SliderChanged:(id)sender{
    [self imageEdit];
}
- (IBAction)stepperChange:(id)sender{
    [self imageEdit];
}
- (IBAction)grayButtonAction:(id)sender{
    self.isGray = !self.isGray; //　Q2.この部分の処理は何のため？　ボタンが押されたかどうかを判定するためのフラグ　bool
    
    [self imageEdit];
   
}

- (void)imageEdit{
    
    //拡大
    UIImage* scaleImage = [self resizeImage:self.editImage];
    //self.imageView.image = scaleImage;
    
    //輝度
    UIImage* slidedImage = [self sliderEdit:scaleImage];
    
    //グレイ
    //if (grayFlag == 1) {
    
    UIImage* grayImages = [self grayImage:slidedImage];
    self.imageView.image = grayImages;
    
}




- (UIImage *)sliderEdit:(UIImage *)scaleImage{
    
    CIImage *filteredImage = [[CIImage alloc] initWithImage:scaleImage]; //ファイル名
    
    // CIFilterを作成
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"
                                  keysAndValues:kCIInputImageKey,filteredImage,@"inputBrightness",[NSNumber numberWithFloat:_sliderBrightness.value],nil];
    
    // フィルタ後の画像を取得
    filteredImage = filter.outputImage;
    
    // CIImageをUIImageに変換する
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [ciContext createCGImage:filteredImage
                                          fromRect:[filteredImage extent]];
    
    NSLog(@"02%lf",_stepperScale.value);
    UIImage *outputImage  = [UIImage imageWithCGImage:imageRef
                                                scale:2.0f
                                          orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    
    return outputImage;
    
}
 


- (UIImage*)resizeImage:(UIImage*)source {
    //(戻り値*)メソッド名:(引数の型*)引数
    
    
    CGFloat scale = _stepperScale.value * 2;
    CGSize resizedSize = CGSizeMake(source.size.width * scale,source.size.height * scale);
    
    UIGraphicsBeginImageContext(resizedSize);
    [source drawInRect:CGRectMake(0, 0, resizedSize.width, resizedSize.height)];
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
    
}


- (UIImage *)grayImage:(UIImage *)slidedImage  {
    
    if (self.isGray) {
        
        [self.grayButton setTitle:@"Reset" forState:UIControlStateNormal];
        
        UIImage *image = slidedImage;
        CGRect imageRect = (CGRect){0.0, 0.0, image.size.width, image.size.height};
        
        // CoreGraphicsのモノクロ色空間を準備します
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        
        // ビットマップコンテキストを作りサイズと色空間を設定します
        CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
        
        // ビットマップコンテキストに画像を描画します
        CGContextDrawImage(context, imageRect, [image CGImage]);
        
        // ビットマップコンテキストに描画された画像を取得します
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        
        // 取得した画像からUIImageを作ります
        UIImage *grayScaleImage = [UIImage imageWithCGImage:imageRef];
        
        // 準備した色空間、ビットマップコンテキスト、取得した画像をメモリから解放します
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(context);
        CFRelease(imageRef);
        
        // Storyboard上のUIImageViewに画像を描画します
        return grayScaleImage;
        
        
        
    } else {
        
        self.grayButton.titleLabel.text = @"Gray";
        [self.grayButton setTitle:@"Gray" forState:UIControlStateNormal];
        
        //self.imageView.image = self.editImage;
        return slidedImage;
}
    // return _imageView.image;
    //return grayScaleImage; こちらは使えない
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageView.image = self.editImage; //IBOutletで接続した画像に前の画面から送られた画像を設定
    self.isGray = NO;// グレイボタンはフラグを使うので準備
    grayFlag = 1;
}

- (void) didReceiveMemoryWarning {
    //メモリ処理
    [super didReceiveMemoryWarning];
}

- (IBAction)saveButtonAction:(id)sender {
    //Saveボタン押下時の処理
    
    SEL selector = @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:);
    //画像を保存する
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, selector, NULL);
}


//画像保存完了時のセレクタ
- (void)onCompleteCapture:(UIImage *)screenImage didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"保存終了" message:@"画像を保存しました" preferredStyle:UIAlertControllerStyleAlert];
    
    // addActionした順に左から右にボタンが配置されます
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // ボタンを押した際に処理が必要ならここに書きます。
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}




@end








