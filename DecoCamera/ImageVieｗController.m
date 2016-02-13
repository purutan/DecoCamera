//
//  ImageVieｗController.m
//  DecoCamera
//
//  Created by 藤田 優介 on 2016/02/07.
//  Copyright © 2016年 yusuke.fujita. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *grayButton;
@property (assign, nonatomic) BOOL isGray;

- (IBAction)saveButtonAction:(id)sender;
- (IBAction)grayButtonAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;

@end

@implementation ImageViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageView.image = self.editImage; //IBOutletで接続した画像に前の画面から送られた画像を設定
    self.isGray = NO; // グレイボタンはフラグを使うので準備
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)saveButtonAction:(id)sender {
    
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



- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
