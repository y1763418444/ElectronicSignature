//
//  ViewController.m
//  ElectronicSignature
//
//  Created by msy on 2017/9/12.
//  Copyright © 2017年 YM. All rights reserved.
//

#import "ViewController.h"
#import "SignViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *signImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signImageView.layer.borderColor = [UIColor redColor].CGColor;
    self.signImageView.layer.borderWidth = 1.0;
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)SignAction:(UIButton *)sender {
    SignViewController *signVC = [[SignViewController alloc] init];
    signVC.signLineColor = [UIColor blueColor];
    [self presentViewController:signVC animated:YES completion:nil];
    [signVC signResultWithBlock:^(UIImage *signImage) {
        self.signImageView.image = signImage;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
