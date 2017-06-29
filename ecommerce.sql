/** CREATE Table Users */
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[Gender] [varchar](50) NOT NULL,
	[Country] [varchar](50) NOT NULL,
	[City] [varchar](50) NOT NULL,
	[Address] [varchar](50) NOT NULL,
	[ContactNO] [varchar](50) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[RegisterdOn] [datetime] NOT NULL,
	[UserType] [varchar](50) NOT NULL,
	[UserStatus] [bit] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_RegisterdOn]  DEFAULT (getdate()) FOR [RegisterdOn]
GO

ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_UserType]  DEFAULT ('buyer') FOR [UserType]
GO

ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_UserStatus]  DEFAULT ((1)) FOR [UserStatus]
GO

ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [chk_Gender] CHECK  (([Gender]='other' OR [Gender]='female' OR [Gender]='male'))
GO

ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [chk_Gender]
GO

ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [CK_UserType] CHECK  (([UserType]='seller' OR [UserType]='buyer'))
GO

ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [CK_UserType]
GO

/** CREATE Table ItemCategory **/
CREATE TABLE [dbo].[ItemCategory](
	[ItemCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ItemCategory] PRIMARY KEY CLUSTERED 
(
	[ItemCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


/** CREATE Table ItemSubCategory **/
CREATE TABLE [dbo].[ItemSubCategory](
	[ItemSubCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[SubCategoryName] [varchar](50) NOT NULL,
	[ItemCategoryID] [int] NOT NULL,
 CONSTRAINT [PK_ItemSubCategory] PRIMARY KEY CLUSTERED 
(
	[ItemSubCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ItemSubCategory]  WITH CHECK ADD  CONSTRAINT [FK_ItemSubCategory_ItemCategory] FOREIGN KEY([ItemCategoryID])
REFERENCES [dbo].[ItemCategory] ([ItemCategoryID])
GO

ALTER TABLE [dbo].[ItemSubCategory] CHECK CONSTRAINT [FK_ItemSubCategory_ItemCategory]
GO

/** CREATE Table Item **/
CREATE TABLE [dbo].[Item](
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[ItemName] [varchar](50) NOT NULL,
	[ItemDescription] [varchar](max) NULL,
	[ItemSubCategoryID] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_Item] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Item] ADD  CONSTRAINT [DF_Item_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_Item_ItemSubCategory] FOREIGN KEY([ItemSubCategoryID])
REFERENCES [dbo].[ItemSubCategory] ([ItemSubCategoryID])
GO

ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_Item_ItemSubCategory]
GO


/** CREATE Table ItemDetails 
	Note: I am using it as a stock.
**/
CREATE TABLE [dbo].[ItemDetails](
	[ItemDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NOT NULL,
	[Quantity] [int] NULL,
	[UserID] [int] NOT NULL,
	[Color] [varchar](50) NULL,
	[Size] [varchar](50) NULL,
	[Weight] [varchar](50) NULL,
	[Price] [decimal](18, 2) NOT NULL,
	[DiscountRate] [decimal](5, 2) NULL,
	[AddedOn] [datetime] NOT NULL,
	[UpdateOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_ItemDetails] PRIMARY KEY CLUSTERED 
(
	[ItemDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ItemDetails] ADD  CONSTRAINT [DF_ItemDetails_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO

ALTER TABLE [dbo].[ItemDetails] ADD  CONSTRAINT [DF_ItemDetails_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [dbo].[ItemDetails]  WITH CHECK ADD  CONSTRAINT [FK_ItemDetails_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO

ALTER TABLE [dbo].[ItemDetails] CHECK CONSTRAINT [FK_ItemDetails_Users]
GO



/** CREATE Table Payment**/

CREATE TABLE [dbo].[Payment](
	[PaymentID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[PayemntType] [varchar](50) NOT NULL,
	[PaymentToken] [varchar](50) NULL,
	[TotalDiscount] [decimal](18, 2) NULL,
	[TotalTax] [decimal](18, 2) NULL,
	[TotalAmount] [decimal](18, 2) NOT NULL,
	[PaymentOnDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Payment] PRIMARY KEY CLUSTERED 
(
	[PaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Payment] ADD  CONSTRAINT [DF_Payment_PaymentOnDate]  DEFAULT (getdate()) FOR [PaymentOnDate]
GO

ALTER TABLE [dbo].[Payment]  WITH CHECK ADD  CONSTRAINT [FK_Payment_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO

ALTER TABLE [dbo].[Payment] CHECK CONSTRAINT [FK_Payment_Users]
GO

/** CREATE Table Purchase **/
CREATE TABLE [dbo].[Purchase](
	[PurchaseID] [int] NOT NULL,
	[ItemDetailsID] [int] NOT NULL,
	[PuchasedFrom] [varchar](50) NOT NULL,
	[PurchasedQuantity] [int] NOT NULL,
	[Cost] [decimal](18, 2) NOT NULL,
	[PurchasedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_Purchase] PRIMARY KEY CLUSTERED 
(
	[PurchaseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Purchase] ADD  CONSTRAINT [DF_Purchase_PurchasedOn]  DEFAULT (getdate()) FOR [PurchasedOn]
GO

ALTER TABLE [dbo].[Purchase]  WITH CHECK ADD  CONSTRAINT [FK_Purchase_ItemDetails] FOREIGN KEY([ItemDetailsID])
REFERENCES [dbo].[ItemDetails] ([ItemDetailsID])
GO

ALTER TABLE [dbo].[Purchase] CHECK CONSTRAINT [FK_Purchase_ItemDetails]
GO

/** CREATE Table Sales **/
CREATE TABLE [dbo].[Sales](
	[SalesID] [int] IDENTITY(1,1) NOT NULL,
	[ItemDetailsID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[Status] [varchar](50) NOT NULL,
	[SalesOn] [datetime] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[PaymentID] [int] NULL,
	[SalesBy] [int] NOT NULL,
 CONSTRAINT [PK_Sales] PRIMARY KEY CLUSTERED 
(
	[SalesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Sales]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Users] FOREIGN KEY([SalesBy])
REFERENCES [dbo].[Users] ([UserID])
GO

ALTER TABLE [dbo].[Sales] CHECK CONSTRAINT [FK_Sales_Users]
GO

ALTER TABLE [dbo].[Sales]  WITH CHECK ADD  CONSTRAINT [CK_Sales_Status] CHECK  (([Status]='Processing' OR [Status]='Completed' OR [Status]='Cancelled'))
GO

ALTER TABLE [dbo].[Sales] CHECK CONSTRAINT [CK_Sales_Status]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sales', @level2type=N'CONSTRAINT',@level2name=N'CK_Sales_Status'
GO

