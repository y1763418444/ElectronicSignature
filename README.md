# ElectronicSignature
电子签名
//初始化后可以直接跳转,也可以配置一些属性.
//注意:跳转签名界面只能使用present方式

SignViewController *signVC = [[SignViewController alloc] init];

signVC.signLineColor = [UIColor blueColor];

[self presentViewController:signVC animated:YES completion:nil];

[signVC signResultWithBlock:^(UIImage *signImage) {

    self.signImageView.image = signImage;
    
}];
