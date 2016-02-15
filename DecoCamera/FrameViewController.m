//
//  FrameViewController.m
//  DecoCamera
//
//  Created by 藤田 優介 on 2016/02/07.
//  Copyright © 2016年 yusuke.fujita. All rights reserved.
//

#import "FrameViewController.h"
#import "ImageViewController.h"


@interface FrameViewController() <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource ,UINavigationControllerDelegate>

//カメラの機能（UIImagePickerController）とUICollectionViewのDelegateを有効化
//Delegate（デリゲート）とは、あるインスタンスから他のインスタンスに通知を送る機能
//Delegateはあるクラスで作成されたメソッドを、他のクラスが任意のタイミングで呼び出すことができる機能

//UIImagePickerControllerはモーダルでの遷移込みで一つの機能になるので、遷移のDelegeteであるUINavigationControllerDelegateと、UIImagePickerControllerDelegateを使う
//UICollectionViewは、UICollectionViewDelegateと、データの管理を行うUICollectionViewDataSourceを使う

// self.collectionView.delegate = self; このコードはstorybordでやったことと同じ　自分自身がcollectionViewのデリゲートになるという宣言


@property (weak,nonatomic) IBOutlet UICollectionView *frameCollectionView;
@property (strong,nonatomic) NSArray *frameArray;
@property (strong,nonatomic) UIImage *editImage;

@end

@implementation FrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.frameArray =  @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15, @16];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionInCollectionView:(UICollectionView *)collectionView {
    //collectionViewがいくつのセクションを持つかを知るために定義しなければならないメソッド
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //collectionViewが画面に表示するアイテム数を知るために定義しなければならないメソッド
    return[self.frameArray count];
}

/*
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //1つ1つの浮世絵フレームを表示するセルを作成するために定義しなければならないメソッド
    
    UICollectionView *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Q3. (UIcollectionView *)を追加した　なぜか
    
    // CollectionView上のUIImageViewをタグを用いて取得します。
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    NSString *imgName = [NSString stringWithFormat:@"frame_%02ld.png", (long)[self.frameArray[indexPath.row] integerValue]];
    UIImage *image = [UIImage imageNamed:imgName];
    imageView.image = image;
    return cell;
}
 全く同じメソッドを書いているつもりなのになぜかワーニングが出る
*/

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //1つ1つの浮世絵フレームを表示するセルを作成するために定義しなければならないメソッド
    
    UICollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    // CollectionView上のUIImageViewをタグを用いて取得します。
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    NSString *imgName = [NSString stringWithFormat:@"frame_%02ld.png", (long)[self.frameArray[indexPath.row] integerValue]];
    UIImage *image = [UIImage imageNamed:imgName];
    imageView.image = image;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //浮世絵を選択した時の処理を記述する
    
       if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //カメラをが使えるかどうか確認
    
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        //カメラを確認
           
    
        
        imagePickerController.delegate = self;
        //デリゲートを自分自信に設定
        
        imagePickerController.allowsEditing = YES; //これで拡大？
           
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 写真モードを選ぶ。（映像モードもある）
           
        imagePickerController.cameraViewTransform = CGAffineTransformTranslate(imagePickerController.cameraViewTransform, 0, 50);
        /*
         ずれ防止
         既存のアフィン変換行列に平行移動の演算を施します。現在の変換行列は、アフィン変換と呼ばれる特殊な行列で、平行移動、回転、拡大縮小の演算
        （座標系を移動、回転、拡大縮小する計算）を施すことにより、ある座標系の点を別の座標系に写像するために使う。
         CG = Core Graphic
        */
        
        
        // UIImagePickerControllerは縦長限定になりますので、正方形にするため、画面を隠します。
        CGRect rect = imagePickerController.view.bounds; //　rect に正方形の一片が入る
        rect.size.height -= imagePickerController.navigationBar.bounds.size.height;  //　A -= B は　A = A-B と同じ意味
        CGFloat barHeight = (rect.size.height - rect.size.width) / 2; //高さから幅を引いて２で割った値を隠すバーにしている
        UIGraphicsBeginImageContext(rect.size); //メモリデバイスコンテキストを使ってメモリ上に画像を作っている
           
        [[UIColor colorWithWhite:0 alpha:1] set];
        UIRectFillUsingBlendMode(CGRectMake(0, 0, rect.size.width, barHeight), kCGBlendModeNormal);
        //多分上側の隠すバーの設定 UIRectFillUsingBlendModeで矩形(四角)を描いている
        UIRectFillUsingBlendMode(CGRectMake(0, rect.size.height - barHeight, rect.size.width, barHeight/1.48), kCGBlendModeNormal); //下側
        UIImage *rimImage = UIGraphicsGetImageFromCurrentImageContext(); //メモリ上の画像を取得
        UIGraphicsEndImageContext(); //メモリデバイスコンテキストを使って画像を作っている
        
        
        // 画面上にフレームなどを置くための土台を作ります。
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        
        // 画面を隠す部分を準備します。
        UIImageView *rimView = [[UIImageView alloc] initWithFrame:rect];
        rimView.image = rimImage; //メモリ上の取得したイメージをimageViewに入れてる
        [baseView addSubview:rimView];

        // フレームを準備します。
        NSString *imgName = [NSString stringWithFormat:@"frame_%02ld.png", (long)[self.frameArray[indexPath.row] integerValue]];
        UIImageView *frameView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        frameView.frame = (CGRect){0, barHeight, rect.size.width, rect.size.width};
        [baseView addSubview:frameView];

        // 画面上にフレームなどを置きます。
        [imagePickerController setCameraOverlayView:baseView]; //OveelayView は setCameraOverLayView にしないと上手くいかない

           
           
           
        // モーダルビューとしてカメラ画面を呼び出す
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
           
           
           
    }
}


/*

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // iphone標準機能の「Use Photo」ボタンを押したあとに didFinishPickingMediaWithInfo: が呼び出される。
    
    [picker dismissViewControllerAnimated:YES completion:nil]; //カメラ(UIImagePickerController)を閉じる。
    
    // Q01.コンテキストとは・・・プログラムの内部状態や置かれた状況、与えられた条件
    
    // 浮世絵フレームと写真は別になっているので合成しなければいけません。
    // キャプチャ対象をWindowにします。
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // これからキャプチャするための作業場所を生成します。
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // １つ１つのWindowの現在の表示内容を作業場所に描画して行きます。
    for (UIWindow *aWindow in [UIApplication sharedApplication].windows) {
        [aWindow.layer renderInContext:context];
    }
    
    // 描画した内容をUIImageとして受け取ります。
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 描画終了 作業場所を廃棄
    UIGraphicsEndImageContext();
    
    // Window全体だと不要な部分があるので、浮世絵フレームを含めた写真の部分だけを切り抜きます
    CGRect rect = picker.view.bounds;
    rect.size.height -= picker.navigationBar.bounds.size.height;
    CGFloat barHeight = (rect.size.height - rect.size.width) / 2;
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width, rect.size.width));
    
    // 画像を描画します。
    [capturedImage drawAtPoint:CGPointMake(0, -barHeight)];
    NSLog(@"値は％0ld",(float)-barHeight);
    capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //今回はキャプチャ画像を使っているが
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    ↑のように書くことでiphoneで撮った画像を使うこともできる
     //
    
    // 描画終了
    UIGraphicsEndImageContext();
    
    self.editImage = capturedImage;
    [self performSegueWithIdentifier:@"ImageView" sender:self]; //画面の遷移
}

*/


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    picker.allowsEditing = true;
    
    // 浮世絵フレームと写真は別になっているので合成しなければいけません。
    // キャプチャ対象をWindowにします。
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // これからキャプチャするための作業場所を生成します。
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // １つ１つのWindowの現在の表示内容を作業場所に描画して行きます。
    for (UIWindow *aWindow in [UIApplication sharedApplication].windows) {
        [aWindow.layer renderInContext:context];
    }
    
    // 描画した内容をUIImageとして受け取ります。
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //capturedImage.allowsEditing = YES;
    
    // 描画終了
    UIGraphicsEndImageContext();
    
    // Window全体だと不要な部分があるので、浮世絵フレームを含めた写真の部分だけを切り抜きます
    CGRect rect = picker.view.bounds;
    rect.size.height -= picker.navigationBar.bounds.size.height;
    CGFloat barHeight = (rect.size.height - rect.size.width) / 2;
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width, rect.size.width));
    
    
    
    // 画像を描画します。
    [capturedImage drawAtPoint:CGPointMake(0, -barHeight)];
    capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 描画終了
    UIGraphicsEndImageContext();
    
   

    self.editImage = capturedImage;
    [self performSegueWithIdentifier:@"ImageView" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //画面の遷移時にこのメソッドが呼び出されます。
    //今回の場合はImageViewの遷移が行われた時、segueで紐づけられた次の画面に画像を渡しています。
    
    
    
    
    //Segueの特定
    if ( [[segue identifier] isEqualToString:@"ImageView"] ) {
        ImageViewController *nextViewController = [segue destinationViewController];
        nextViewController.editImage = self.editImage;
    }
}



@end

