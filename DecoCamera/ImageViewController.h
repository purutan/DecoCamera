//
//  ImageVieｗController.h
//  DecoCamera
//
//  Created by 藤田 優介 on 2016/02/07.
//  Copyright © 2016年 yusuke.fujita. All rights reserved.
//

//  なぜか最初に　@interface ImageVie_Controller になっていた

//  FrameViewControllerでは画像に合成するフレームの選択を行う


#import "ViewController.h"

@interface ImageViewController : ViewController

@property (strong, nonatomic) UIImage *editImage;

@end