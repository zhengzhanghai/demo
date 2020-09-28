//
//  ViewController.m
//  KeychainDemo
//
//  Created by 郑章海 on 2020/9/28.
//

#import "ViewController.h"
@import SAMKeychain;

@interface ViewController ()

@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lock = [[NSLock alloc] init];
    _queue = dispatch_queue_create("label", DISPATCH_QUEUE_SERIAL);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
//    [self testSet];
//    [self testGet];
//    [self testDelete];
//    [self testString];
    
    
    static BOOL flag = true;
    if (flag) {
        [self testThread];
    } else {
        NSLog(@"%@", [SAMKeychain passwordForService:@"service1111" account:@"acount22222"]);
    }
    flag = !flag;
    
    
}

- (void)testSet {
    NSTimeInterval time1 = [self printTimeNow];
    [SAMKeychain setPassword:@"password" forService:@"service1111" account:@"acount22222"];
    NSTimeInterval time2 = [self printTimeNow];
    int time = (time2 - time1) * 1000;
    [self showToTime:time y:50 flag:@"添加"];
}

- (void)testGet {
    NSTimeInterval time1 = [self printTimeNow];
    [SAMKeychain passwordForService:@"service1111" account:@"acount22222"];
    NSTimeInterval time2 = [self printTimeNow];
    int time = (time2 - time1) * 1000;
    [self showToTime:time y:100 flag:@"获取"];
}

- (void)testDelete {
    NSTimeInterval time1 = [self printTimeNow];
    [SAMKeychain deletePasswordForService:@"service1111" account:@"acount22222"];
    NSTimeInterval time2 = [self printTimeNow];
    int time = (time2 - time1) * 1000;
    [self showToTime:time y:150 flag:@"删除"];
}

- (void)testString {
    NSTimeInterval time1 = [self printTimeNow];
    NSString *string = [NSString stringWithFormat:@"困了就睡带盒饭卡仕达官方跨境电商法卡萨国防科技梵蒂冈开始"];
    NSTimeInterval time2 = [self printTimeNow];
    NSTimeInterval time = (time2 - time1) * 1000;
    [self showToTime:time y:200 flag:@"字符串"];
}

- (void)testThread {
    for (int i = 0; i < 1000; i++) {
        dispatch_async(_queue, ^{
//            [self.lock lock];
            NSString *string = [NSString stringWithFormat:@"password %d", i];
            [SAMKeychain setPassword:string forService:@"service1111" account:@"acount22222"];
//            [self.lock unlock];
        });
    }
    
//    for (int i = 0; i < 1000; i++) {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            NSLog(@"%@", [SAMKeychain passwordForService:@"service1111" account:@"acount22222"]);
//        });
//    }
    
//    for (int i = 0; i < 1000; i++) {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [SAMKeychain deletePasswordForService:@"service1111" account:@"acount22222"];
//        });
//    }
}

- (void)showToTime:(NSTimeInterval)time y:(CGFloat)y flag:(NSString *)flag {
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(100, y, 200, 30);
    label.text = [NSString stringWithFormat:@"%@: %lf ms", flag, time];
    [self.view addSubview:label];
}

- (NSTimeInterval)printTimeNow {
    NSDate *date = [NSDate date];
    NSTimeInterval interval = [date timeIntervalSince1970];
    return interval;
}


@end
