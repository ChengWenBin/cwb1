1.用户管理：管理员功能，用于增删改查用户的信息，用户也可以在系统的登录页有注册功能，注册后登录可以正常获得基础数据。

2.角色管理：超级管理员功能，用于分配用户的角色信息（管理员和用户）并分配对应的数据权限。

3.电子产品管理：管理员功能，用于电子产品的增删改查。

4.电子产品浏览：用户功能，展示所有在售的电子产品的各种信息，用户可以将心仪的产品添加到购物车中，还有基础的查询功能（通过产品类别、产品价格区间、库存数量），找到符合自己要求的产品。

5.购物车：用户功能，展示用户在电子产品浏览界面添加到购物车的产品，可以修改购买的产品数量。内置两个功能按钮：清空购物车和生成订单，点击清空购物车后，购物车中的产品被移除，点击生成订单后将产品添加到我的订单中。（点击生成订单后会弹窗：输入收获地址）。

6.我的订单：用户功能，有订单编号，订单总金额，收货地址，订单状态等信息，有操作按钮：详细、支付、取消、备注。点击详细后会出现这个订单的所有商品的信息，点击支付后会弹窗一个确认支付的按钮，确定后订单状态自动从待付款变为代发货。取消订单后状态变为已取消，备注按钮点后会添加所需要的备注。订单详细页会有下单时间、付款时间、发货时间、完成时间、收货地址等信息。

7.订单管理：管理员功能，能看到所有用户的订单信息，可以通过不同查询条件筛选订单（订单编号、用户id、状态、最小金额、最大金额），管理员可以修改订单状态，修改后在订单详细页面系统会自动捕捉操作时间，然后记录到订单详细页里。

8.数据看板：用户功能，展示销售趋势和订单数量趋势（折线图）、产品销售分布和订单状态分布（饼图），还可以导出产品销售数据（每个产品的销售数量和销售总金额）和订单数据（各个订单的信息）的excel报表。

注：库存是动态变化的，当订单生成后，根据订单中的对应产品的数量，商品库存会对应变化。当产品库存为0时，用户无法下单对应的产品。