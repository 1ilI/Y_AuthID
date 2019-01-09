//
//  ViewController.m
//  Y_AuthIDExample
//
//  Created by Yue on 2018/1/11.
//  Copyright © 2018年 Yue. All rights reserved.
//

#import "ViewController.h"
#import "Y_AuthID.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (copy, nonatomic) NSArray *dataArr;
@property (strong, nonatomic) UILabel *headTitleLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Y_AuthID 身份校验";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSString *title = [NSString string];
    if (![Y_AuthID deviceCanSupport]) {
        title = @"该设备不支持生物验证";
    }
    if ([Y_AuthID canSupportFaceID]) {
        title = @"该设备支持 Face ID 验证";
    }
    self.dataArr = @[
                     @"解锁失败，无右侧输入密码，无密码验证界面",
                     @"解锁失败，有右侧输入密码，无密码验证界面",
                     @"解锁失败，无右侧输入密码，有密码验证界面",
                     @"解锁失败，有右侧输入密码，有密码验证界面",
                     title];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _headTitleLabel.frame = CGRectMake(15, 0, self.view.frame.size.width - 30, 80);
}

- (UILabel *)headTitleLabel {
    if (!_headTitleLabel) {
        UILabel *label = [UILabel new];
        label.numberOfLines = 0;
        label.text = @"对于 iOS11 及以上有 Face ID 的机器 \n info.plist 中一定要填写 \n【 Privacy - Face ID Usage Description 】字段";
        _headTitleLabel = label;
    }
    return _headTitleLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [headView addSubview:self.headTitleLabel];
    return headView;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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


@end
