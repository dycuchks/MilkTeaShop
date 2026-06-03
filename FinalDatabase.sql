-- =============================================
-- 遇见·好茶 最终完整版数据库脚本
-- 包含：Users, Products, Orders, OrderDetails 四张表
-- =============================================

-- 1. 重置/创建 用户表 (Users)
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
CREATE TABLE [Users] (
    [Id] INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    [Username] NVARCHAR(50) NOT NULL UNIQUE,
    [Password] NVARCHAR(50) NOT NULL,
    [UserType] INT DEFAULT(1) NOT NULL, -- 1:顾客, 2:管理员
    [Phone] NVARCHAR(20),
    [Address] NVARCHAR(200)
);

-- 2. 重置/创建 商品表 (Products)
IF OBJECT_ID('Products', 'U') IS NOT NULL DROP TABLE Products;
CREATE TABLE [Products] (
    [Id] INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    [ProductName] NVARCHAR(100) NOT NULL,
    [Category] NVARCHAR(50),
    [Price] DECIMAL(18, 2) NOT NULL,
    [Description] NVARCHAR(MAX),
    [ImageUrl] NVARCHAR(200) DEFAULT('/Images/tea1.jpg')
);

-- 3. 重置/创建 订单主表 (Orders)
-- 包含了我们后来新增的 ReceiverAddress 和 ReceiverPhone 字段
IF OBJECT_ID('Orders', 'U') IS NOT NULL DROP TABLE Orders;
CREATE TABLE [Orders] (
    [Id] INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    [UserId] INT NOT NULL,
    [OrderDate] DATETIME DEFAULT(GETDATE()),
    [TotalAmount] DECIMAL(18, 2) DEFAULT(0),
    [Status] NVARCHAR(20) DEFAULT(N'购物车'),
    [ReceiverAddress] NVARCHAR(200), -- 收货地址
    [ReceiverPhone] NVARCHAR(50)     -- 收货电话
);

-- 4. 重置/创建 订单明细表 (OrderDetails)
IF OBJECT_ID('OrderDetails', 'U') IS NOT NULL DROP TABLE OrderDetails;
CREATE TABLE [OrderDetails] (
    [Id] INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    [OrderId] INT NOT NULL,
    [ProductId] INT NOT NULL,
    [Quantity] INT NOT NULL DEFAULT(1),
    [PriceAtTime] DECIMAL(18, 2) NOT NULL
);

-- =============================================
-- 插入初始化测试数据
-- =============================================

-- 插入管理员和测试用户
INSERT INTO [Users] (Username, [Password], UserType, Phone, Address) VALUES 
('admin', '123456', 2, '13800000000', '管理员办公室'),
('user', '123456', 1, '13900000000', '学生宿舍A栋302');

-- 插入12款经典奶茶
INSERT INTO [Products] (ProductName, Category, Price, Description, ImageUrl) VALUES 
(N'经典珍珠奶茶', N'经典', 12, N'超Q弹珍珠，经典回味', '/Images/tea1.jpg'),
(N'杨枝甘露', N'果茶', 18, N'精选鲜芒，酸甜清爽', '/Images/tea4.jpg'),
(N'多肉葡萄', N'果茶', 19, N'手剥葡萄，果肉满满', '/Images/tea5.jpg'),
(N'芝芝莓莓', N'奶盖', 22, N'咸芝士奶盖配草莓', '/Images/tea8.jpg'),
(N'抹茶拿铁', N'牛乳', 16, N'宇治抹茶，口感丝滑', '/Images/tea12.jpg'),
(N'阿萨姆奶茶', N'经典', 13, N'经典红茶基底', '/Images/tea2.jpg'),
(N'桃桃乌龙', N'果茶', 18, N'白桃乌龙，香气扑鼻', '/Images/tea6.jpg'),
(N'四季春奶盖', N'奶盖', 15, N'高山茶底，清新回甘', '/Images/tea9.jpg'),
(N'芋泥波波鲜奶', N'牛乳', 16, N'手捣绵密芋泥', '/Images/tea10.jpg'),
(N'焦糖玛奇朵', N'经典', 15, N'甜蜜焦糖，咖啡香浓', '/Images/tea3.jpg'),
(N'满杯金桔柠檬', N'果茶', 14, N'维C满满，酸甜解腻', '/Images/tea7.jpg'),
(N'黑糖鹿丸鲜奶', N'牛乳', 17, N'古法黑糖，挂壁纹路', '/Images/tea11.jpg');