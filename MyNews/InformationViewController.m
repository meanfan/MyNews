//
//  InformationViewController.m
//  MyNews
//
//  Created by cocoa on 2019/6/12.
//  Copyright © 2019 MyNews. All rights reserved.
//

#import "InformationViewController.h"

@interface InformationViewController ()

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"姓名";
        if (dic && [dic objectForKey:@"name"]) {
           cell.detailTextLabel.text = [dic objectForKey:@"name"];
        }else{
            cell.detailTextLabel.text = @"点击录入信息";
        }
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"学号";
        if (dic && [dic objectForKey:@"no"]) {
            cell.detailTextLabel.text = [dic objectForKey:@"no"];
        }else{
            cell.detailTextLabel.text = @"点击录入信息";
        }
    }else{
        cell.textLabel.text = @"性别";
        if (dic && [dic objectForKey:@"sex"]) {
            cell.detailTextLabel.text = [dic objectForKey:@"sex"];
        }else{
            cell.detailTextLabel.text = @"点击录入信息";
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入姓名" preferredStyle:UIAlertControllerStyleAlert];
        //增加取消按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //增加确定按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //获取第1个输入框；
            UITextField *userNameTextField = alertController.textFields.firstObject;
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
            NSMutableDictionary *muDic  ;
            if (!dic) {
                muDic = [NSMutableDictionary dictionary];
            }else{
                muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            }
            [muDic setObject:userNameTextField.text forKey:@"name"];
            NSLog(@"姓名 = %@",userNameTextField.text);
            [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:muDic] forKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }]];
        //定义第一个输入框；
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入姓名";
        }];
        [self presentViewController:alertController animated:true completion:^{
           
        }];
    } else if (indexPath.row == 1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入学号" preferredStyle:UIAlertControllerStyleAlert];
        //增加取消按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //增加确定按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //获取第1个输入框；
            UITextField *userNameTextField = alertController.textFields.firstObject;
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
            NSMutableDictionary *muDic  ;
            if (!dic) {
                muDic = [NSMutableDictionary dictionary];
            }else{
                muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            }
            [muDic setObject:userNameTextField.text forKey:@"no"];
            NSLog(@"学号 = %@",userNameTextField.text);
            [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:muDic] forKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }]];
        //定义第一个输入框；
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入学号";
        }];
        [self presentViewController:alertController animated:true completion:^{
            
        }];
    } else {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
            
        }];
        UIAlertAction *man = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
            NSMutableDictionary *muDic  ;
            if (!dic) {
                muDic = [NSMutableDictionary dictionary];
            }else{
                muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            }
            [muDic setObject:@"男" forKey:@"sex"];
            NSLog(@"性别 = %@",@"男");
            [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:muDic] forKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
        
        UIAlertAction *female = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
            NSMutableDictionary *muDic  ;
            if (!dic) {
                muDic = [NSMutableDictionary dictionary];
            }else{
                muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            }
            [muDic setObject:@"女" forKey:@"sex"];
            NSLog(@"性别 = %@",@"女");
            [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:muDic] forKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
        [alertVc addAction:cancle];
        [alertVc addAction:man];
        [alertVc addAction:female];
        [self presentViewController:alertVc animated:YES completion:^{
           
        }];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
