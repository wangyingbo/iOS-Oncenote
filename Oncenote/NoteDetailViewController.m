//
//  NoteDetailViewController.m
//  Oncenote
//
//  Created by chenyufeng on 15/11/14.
//  Copyright © 2015年 chenyufengweb. All rights reserved.
//

#import "NoteDetailViewController.h"
#import <BmobSDK/Bmob.h>
#import "MainViewController.h"
#import "AppDelegate.h"
#import "Constant.h"


@interface NoteDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *shareImageView;
@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;

@property (weak, nonatomic) IBOutlet UITextField *noteTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *noteTextTextView;

@end

@implementation NoteDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.noteTitleTextField.text = self.noteTitle;
  self.noteTextTextView.text = self.noteText;
  NSLog(@"noteId;%@",self.noteId);
  
  
  //控件绑定操作；
  [self.backImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noteDetailBackButtonPressed:)]];
  
}


#pragma mark - 所有的按钮点击操作
- (void) noteDetailBackButtonPressed:(id)sender{
  
  //使用显式界面跳转,因为需要执行MainViewController的viewDidLoad()方法；
  //  UIViewController *mainViewController = [[UIViewController alloc] init];
  //  mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
  //  [self presentViewController:mainViewController animated:true completion:nil];
  
  [self updateBmobObject:NOTE_TABLE noteId:self.noteId noteTitle:self.noteTitleTextField.text noteText:self.noteTextTextView.text];
  
}

#pragma mark - 修改笔记
-(void)updateBmobObject:(NSString*)tableName  noteId:(NSString*)noteId noteTitle:(NSString*)noteTitle noteText:(NSString*)noteText{
  //查找GameScore表
  BmobQuery   *bquery = [BmobQuery queryWithClassName:tableName];
  [bquery getObjectInBackgroundWithId:noteId block:^(BmobObject *object,NSError *error){
    if (!error) {
      if (object) {
        //设置cheatMode为YES
        [object setObject:noteTitle forKey:@"noteTitle"];
        [object setObject:noteText forKey:@"noteText"];
        
        //异步更新数据
        [object updateInBackground];
      }
    }else{
      //进行错误处理
    }
  }];
  
  
  
  //使用显式界面跳转,因为需要执行MainViewController的viewDidLoad()方法；
  MainViewController *mainViewController = [[MainViewController alloc] init];
  mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
  mainViewController.tempIndexPath = self.indexPath;
  mainViewController.tempTitle = self.noteTitleTextField.text;
  mainViewController.tempText = self.noteTextTextView.text;
  
  [self presentViewController:mainViewController animated:true completion:nil];
  
  
}

@end
