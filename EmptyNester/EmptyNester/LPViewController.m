//
//  LPViewController.m
//  EmptyNester
//
//  Created by shao on 16/5/14.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "LPViewController.h"
#import "NoteCell.h"
#import "MemorandumModel.h"
#import "CSModelTool.h"
#import "AddNote.h"
#import "EditNote.h"
#import "UITableView+EmptyData.h"
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define shitYellow RGB(253, 178, 50)

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define iphone6_ScreenWidth 375.0
#define iphone6_ScreenHeight 667.0

#define kWindowWidth ([UIScreen mainScreen].bounds.size.width)
#define kWindowHeight ([UIScreen mainScreen].bounds.size.height)

#define kWidthRatio kScreenWidth/iphone6_ScreenWidth
#define kHeightRatio kScreenHeight/iphone6_ScreenHeight

@interface LPViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *MainTableView; // 主表格
}

@property (nonatomic, strong) NSMutableArray *modalsArrM;
@property (nonatomic, strong) FMDatabase *fmdb;


@end

@implementation LPViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (NSMutableArray *)modalsArrM {
    if (!_modalsArrM) {
        _modalsArrM = [[NSMutableArray alloc] init];
    }
    return _modalsArrM;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initNoteData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNumber *isExit = [[NSUserDefaults standardUserDefaults]objectForKey:@"NoteIdentifier"];
    if(!isExit){
        NSNumber *NoteIdentifier = @1000;
        [[NSUserDefaults standardUserDefaults] setValue:NoteIdentifier forKey:@"NoteIdentifier"];
    }
    else{
        NSLog(@"看看备忘录标识ID是多少:%@",isExit);
    }
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LPView" bundle:nil];
    UINavigationController* view = [storyboard instantiateInitialViewController];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"生活计划";
    UIBarButtonItem *addBtn=[[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(AddClick)]; // 新建按钮
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : shitYellow}]; // 标题颜色
    self.navigationController.navigationBar.tintColor = shitYellow; // 左右按钮颜色
    self.navigationItem.rightBarButtonItem=addBtn;
    
    [self setMainTableView];
}
- (void)setMainTableView
{
    MainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
    MainTableView.dataSource = self;
    MainTableView.delegate = self;
    [self.view addSubview:MainTableView];
}

// 查询备忘录(初始化
- (void)initNoteData
{
    [self.modalsArrM removeAllObjects];
    NSArray *modals = [CSModelTool queryData:nil];
    NSArray *tempArr = [[modals reverseObjectEnumerator] allObjects]; // 将数组倒序排列
    [self.modalsArrM addObjectsFromArray:tempArr];
    [MainTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [tableView tableViewDisplayWitMsg:@"您还没有写计划" ifNecessaryForRowCount:self.modalsArrM.count];
    return self.modalsArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identfiy = @"cellID";
    NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:identfiy];
    if(!cell){
        cell = [[NoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfiy];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setNoteData:self.modalsArrM[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditNote *edit = [[EditNote alloc] init];
    edit.model = self.modalsArrM[indexPath.row];
    [self.navigationController pushViewController:edit animated:YES];
}

#pragma cell编辑模式--------删除备忘录
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){ //删除模式
        [CSModelTool deleteData:self.modalsArrM[indexPath.row]];
        //[MainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self initNoteData]; // 重新查询数据刷新表格
}


#pragma  自定义左滑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25 * kHeightRatio + 34.5;
}

// 新建备忘录
- (void)AddClick
{
    AddNote *add = [[AddNote alloc] init];
    [self.navigationController pushViewController:add animated:YES];
}
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"___" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"___.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
