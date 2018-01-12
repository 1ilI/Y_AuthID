//
//  Y_ViewController.m
//  Y_AuthID
//
//  Created by zhangyue369581379@qq.com on 01/12/2018.
//  Copyright (c) 2018 zhangyue369581379@qq.com. All rights reserved.
//

#import "Y_ViewController.h"
#import "Y_AuthID.h"

@interface Y_ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (copy, nonatomic) NSArray *dataArr;


@end

@implementation Y_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dataArr = @[@"无右侧输入密码，无解锁生物验证界面",
                     @"有右侧输入密码，无解锁生物验证界面",
                     @"无右侧输入密码，有解锁生物验证界面",
                     @"有右侧输入密码，有解锁生物验证界面"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentify = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    cell.textLabel.text = _dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL hasInput = NO;
    BOOL needUnlock = NO;
    if (indexPath.row == 1) {
        hasInput = YES;
    }
    else if (indexPath.row == 2) {
        needUnlock = YES;
    }
    else if (indexPath.row == 3) {
        hasInput = YES;
        needUnlock = YES;
    }
    else {
        hasInput = NO;
        needUnlock = NO;
    }
    [self showAuthIDHasInputPassword:hasInput needUnlock:needUnlock];
}


- (void)showAuthIDHasInputPassword:(BOOL)hasInput  needUnlock:(BOOL)needUnlock {
    [Y_AuthID showAuthIDHasInputPassword:hasInput needUnlock:needUnlock result:^(Y_AuthIDType authIDType, NSError *error, NSString *message) {
        if (authIDType == Y_AuthIDTypeSuccess) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"验证成功" message:message preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            NSLog(@"--->%@",message);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
