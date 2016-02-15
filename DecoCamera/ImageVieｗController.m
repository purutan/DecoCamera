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



- (IBAction)SliderChanged:(id)sender{
    
    //スライダーの値を取得
    //  float slider = _slider.value;
    // _slider.minimumValue = -0.5f; StoryBordにて決める
    // _slider.maximumValue = 0.5;　Storybordにて決める
    
    // 元画像を取得
    //UIImage *originImage = self.editImage;
    
    // UIImageをCIImageに変換
    //CIImage *filteredImage = [[CIImage alloc] initWithCGImage:originImage.CGImage];
    CIImage *filteredImage = [[CIImage alloc] initWithImage:self.editImage]; //ファイル名
    
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
                                                scale:0.5f
                                          orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    
    // 表示
    //[self.view addSubview:outputImage];
    self.imageView.image = outputImage;
    
}


- (UIImage*)resizeImage:(UIImage*)source {
    //(戻り値*)メソッド名:(引数の型*)引数
    
    
    CGFloat scale = _stepperScale.value;
    CGSize resizedSize = CGSizeMake(source.size.width * scale,source.size.height * scale);
    
    UIGraphicsBeginImageContext(resizedSize);
    [source drawInRect:CGRectMake(0, 0, resizedSize.width, resizedSize.height)];
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
    
}

- (IBAction)stepperChange:(id)sender {
    
    UIImage* scaleImage = [self resizeImage:self.editImage];
    
    self.imageView.image = scaleImage;

    
    
    ///
    
    // リサイズ例文（割合を指定する方法）
    
    //UIImage作成
    //UIImage *image = self.editImage;
    
    //UIImageView作成
    //UIImageView *imageViewS =[[UIImageView alloc]initWithImage:image];
    
    //CGFloat xScale = _stepperScale.value; // x軸方向に0.5倍
    //CGFloat yScale = _stepperScale.value; // y軸方向に0.5倍
    //self.imageView.transform = CGAffineTransformMakeScale(xScale, yScale);
    
    

    
    
    //self.imageView.image = CGAffineTransformMakeScale(xScale, yScale);
    
    
    //UIImage *imagescale = imageView.image;
    //self.imageView.image = nil;
    //self.imageView.image = imagescale;
    //self.imageView.image = imageViewS.image;

    //[self.imageView:imageView];
    
    
    //UIImage *grayScaleImage = [UIImage i:imageView];
    //UIImage *output = [[UIImage alloc]initWithCIImage:imageView];
    //self.imageView.image = output;
    
    
    
    /// uiimgaeView から　uiImgae に
    /*
     UIImage* image;
     
     // UIView のサイズの画像コンテキストを開始します。
     UIGraphicsBeginImageContext(view.frame.size);
     
     // 開始した画像コンテキストを取得します。
     CGContextRef context = UIGraphicsGetCurrentContext();
     
     // UIView の内容を、開始した画像コンテキストへ書き出させます。
     [view.layer renderInContext:context];
     
     // 画像コンテキストから画像を生成します。
     image = UIGraphicsGetImageFromCurrentImageContext();
     
     // 画像コンテキストを終了します。
     UIGraphicsEndImageContext();
     
     return image;
    
     
     
     - (UIImage*)resizeImage:(UIImage*)source
     {
     CGFloat scale = 1;
     CGSize resizedSize = CGSizeMake(source.size.width * scale,source.size.height * scale);
     
     UIGraphicsBeginImageContext(resizedSize);
     [source drawInRect:CGRectMake(0, 0, resizedSize.width, resizedSize.height)];
     UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     return resultImage;
     }
     
     
     
     
     // UIViewのサイズの 画像コンテキストを開始
     UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [UIScreen mainScreen].scale);
     
     CGContextRef context = UIGraphicsGetCurrentContext();
     [self.layer renderInContext:context];
     image = UIGraphicsGetImageFromCurrentImageContext();
     
     // 画像コンテキストを終了
     UIGraphicsEndImageContext();
     
     return image;
     
    */
    ///
    
    
    
    
    
    //UIImage *outputImageScale = [[UIImage alloc]init:imageView];
    
    //[self.view addSubview:imageView]; 動くが上書きほぞんみたいな感じ
    
    //self.imageView.image = imageView.image;
    //self.imageView.image = outputImageScale;
    
    
    // view に ImageView を追加する
    
    /*
    
    //UIImage作成
    //UIImage *image =[UIImage imageNamed:@"sample.jpg"];
    
    UIImage *imageView = self.imageView.image;
    
    // 画像の幅
    CGFloat width = imageView.size.width;
    // 画像の高さ
    CGFloat height = imageView.size.height;
    // 拡大・縮小率
    CGFloat scale = _stepperScale.value;
    
    //UIImageView作成
    UIImageView *imageViewScale =[[UIImageView alloc]initWithImage:imageView];
    
    // 画像サイズ変更
    CGRect rect = CGRectMake(0, 0, width*scale, height*scale);
    
    // ImageView frame をCGRectMakeで作った矩形に合わせる
     imageViewScale.frame = rect;
    
    // view に ImageView を追加する
    //imageViewScale は　UIImageView
    //ImageView とは別
    
    //[editViewController.chosenImage setImage:imageViewScale];
    
    self.imageView.image = imageViewScale.image;
    //[self.imageView addSubview:imageViewScale];
    //ストーリーボード上のimageに展開
    
    */
    /*
     // リサイズ例文（割合を指定する方法）
     
     //UIImage作成
     UIImage *image =[UIImage imageNamed:@"sample.jpg"];
     
     //UIImageView作成
     UIImageView *imageView =[[UIImageView alloc]initWithImage:image];
     
     CGFloat xScale = 0.5f; // x軸方向に0.5倍
     CGFloat yScale = 0.5f; // y軸方向に0.5倍
     imageView.transform = CGAffineTransformMakeScale(xScale, yScale);
     [self.view addSubview:imageView];
     
     */
    
    
    
}



- (IBAction)grayButtonAction:(id)sender {
    //IBAction の本体
    
    self.isGray = !self.isGray; //　Q2.この部分の処理は何のため？ viewDidLoadでNoにしてたが・・・　初期化？
    
    if (self.isGray) {
        
        [self.grayButton setTitle:@"Reset" forState:UIControlStateNormal];
        
        UIImage *image = self.editImage;
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
        self.imageView.image = grayScaleImage;
    } else {
        
        self.grayButton.titleLabel.text = @"Gray";
        [self.grayButton setTitle:@"Gray" forState:UIControlStateNormal];
        
        self.imageView.image = self.editImage;
    }

}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageView.image = self.editImage; //IBOutletで接続した画像に前の画面から送られた画像を設定
    self.isGray = NO; // グレイボタンはフラグを使うので準備
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








