# c++标准库算法概览


## 参考

1. 《C++ Primer 第5版》
2. [cppreference.com](https://en.cppreference.com/w/)

## 说明

本节内容包括：5类迭代器、算法形参模式、算法命名规范、特定容器算法。

### 5类迭代器

算法所要求的迭代器操作可以分为5个迭代器类别，每个算法都会对它的每个迭代器参数指明须提供哪类迭代器。

* **输入迭代器**：只读，不写；单遍扫描，只能递增。  
例如，`istream_iterator`是一种输入迭代器。
* **输出迭代器**：只写，不读；单遍扫描，只能递增。  
例如：`ostream_iterator`是一种输出迭代器。
* **前向迭代器**：可读写，多遍扫描，只能递增。  
`forward_list`上的迭代器是前向迭代器。
* **双向迭代器**：可读写，多遍扫描，可递增递减。  
除了`forward_list`外，其他标准库容器都提供双向迭代器。
* **随机访问迭代器**：可读写，多遍扫描，支持全部迭代器运算。  
`array`、`deque`、`string`、`vector`的迭代器都是随机访问迭代器。  
注意：只有顺序容器才有随机访问迭代器，只有顺序容器才能用下标访问元素。顺序容器本身和顺序容器的迭代器都有下标运算符`"[]"`。（见书中第310页和第367页）

**一个高层类别的迭代器支持低层类别迭代器的所有操作**。C++标准指明了泛型和数值算法的每个迭代器参数的最小类别。

### 算法形参模式

算法有一组参数规范。大多数算法具有如下4种形式之一：

* `alg(beg, end, other args);`
* `alg(beg, end, dest, other args);`
* `alg(beg, end, beg2, other args);`
* `alg(beg, end, beg2, end2, other args);`

`alg`是算法名字，`beg`和`end`是算法所操作的输入范围。`dest`参数是一个表示算法可以写入的目的位置的迭代器。算法假定：按其需要写入数据，不管写入多少个元素都是安全的。只接受单独`beg2`的算法将`beg2`作为**第二个输入范围**中的首元素。算法假定从`beg2`开始的范围与`beg`和`end`所表示的范围至少一样大。

还有一些其他的算法形参。`unaryPred`和`binaryPred`是一元和二元谓词，分别接受一个和两个参数，都是来自输入序列的元素，两个谓词都返回可用作条件的类型。`comp`是一个二元谓词,满足关联容器中对关键字序的要求。`unaryOp`和`binaryOp`是可调用对象，可分别使用来自输入序列的一个和两个实参来调用。**谓词和可调用对象的区别在于谓词必须返回bool类型的值**。

### 算法命名规范

除了参数规范，算法还遵循一套命名和重载规范。

* 使用重载形式传递一个谓词
* `_if`版本的算法  
接受一个元素值的算法通常有一个`_if`版本，该版本接受一个谓词代替元素值。
* `_copy`版本的算法

### 特定容器算法

链表`list`和`forward_list`定义了几个成员函数形式的算法。特别是，它们定义了独有的`sort`、`merge`、`remove`、`reverse`和`unique`。链表类型定义的其他算法的通用版本可以用于链表，但代价太高。链表可以通过改变元素间的链接而不是真的交换它们的值来快速“交换”元素。链表类型定义了特有的`splice`算法，该算法是链表数据结构特有的，因此没有通用版本。  
**链表特有版本与通用版本的一个重要区别就是链表版本会改变底层的容器！**  
`string`类也提供了一些特有的算法，如替换、搜索、比较、数值转换等算法。

### 头文件

* `functional`  
通用函数适配器`bind`。
* `iterator`  
流迭代器`istream_iterator`和`ostream_iterator`。
* `utility`  
`pair`类型；`std::dest`函数。
* `algorithm`
声明了大多数算法。
* `numeric`
声明了数值算法。

### 其他内容

* 迭代器适配器  
插入迭代器是一种迭代器适配器。有三种插入迭代器，差异在于元素插入的位置：`back_inserter`、`front_inserter`、`inserter`。
* 流迭代器（流迭代器是迭代器适配器吗？）
* 函数适配器  
`bind`函数在头文件`functional`中，是一个通用函数适配器。
`bind`所用到的名字`_n`定义在一个名为`placeholders`的命名空间中，而这个命名空间本身定义在`std`命名空间。例如，`_1`的声明为：`using std::placeholders::_1;`  

* lambda表达式


### 一些经验

* 对于不修改容器元素值的算法，可以传递`const`迭代器参数。
* 有些算法返回的是指向元素的迭代器。对于顺序容器，可以采用迭代器相减的办法获得元素下标。对于链式容器，则只能采用遍历容器的方式得到元素的下标。
* 谓词和可调用对象的区别在于谓词必须返回`bool`类型的值。
* 如果一个算法需要二元谓词，在传入的两个元素中，靠左的元素会作为二元谓词的第一个参数，靠右的元素会作为二元谓词的第二个参数。
* 查找对象的算法在未找到元素的情况下会返回`end`，注意这个`end`是作为参数传递给算法的那个`end`，而不是容器真正的`end`迭代器。
* 说某个序列是“有序的”指的是该序列按从小到大的顺序排列。
* 只有顺序容器才有随机访问迭代器，只有顺序容器才能用下标访问元素。顺序容器本身和顺序容器的迭代器都有下标运算符`"[]"`。（见书中第310页和第367页）
* `nth_element`是个划分算法，不是个排序算法。

## 查找对象的算法

在一个输入序列中搜索一个指定值或一个值的序列。每个算法提供两个重载版本，第一个版本使用`"=="`运算符比较元素，第二个版本使用`unaryPred`和`binaryPred`比较元素。

### **简单查找算法**

这些算法查找指定值，要求**输入迭代器**。

>`find(beg, end, val)`  
`find_if(beg, end, unaryPred)`  
`find_if_not(beg, end, unaryPred)`  

* 要求输入迭代器。
* 这三个算法**返回一个迭代器**，指向第一个“等于`val`/满足条件/不满足条件”的元素。
* 这三个算法**在没有找到元素时**都返回`end`。

>`count(beg, end, val)`  
`count_if(beg, end, unaryPred)`

* 要求输入迭代器。
* 这两个算法返回一个数，统计有多少个等于`val`或者满足条件的元素。

>`all_if(beg, end, unaryPred)`  
`any_if(beg, end, unaryPred)`  
`none_if(beg, end, unaryPred)`

* 要求输入迭代器。
* 这些算法都返回`bool`值，分别指出是否所有元素都满足条件、是否存在满足条件的元素、是否所有元素都不满足条件。
* **如果序列为空**，`any_of`返回`false`，`all_of`和`none_of`返回`true`。

### **查找（相邻）重复值的算法**

这些算法在输入序列中查找重复元素。要求**前向迭代器**。

>`adjacent_find(beg, end)`  
`adjacent_find(beg, end, binaryPred)`

* 要求前向迭代器。
* **返回**指向第一对相邻重复元素的**迭代器**，指向两个元素中的前一个元素。
* 如果序列中无相邻重复元素，则返回`end`。
* 虽说这个算法需要前向迭代器，但是传参时传入`vi.cbegin()`后算法也能正常执行（测试序列是一个`vector<int>`）。
* 二元谓词用来判断两个元素是否相等。

>`search_n(beg, end, count, val)`  
`search_n(beg, end, count, val, binaryPred)`

* 要求前向迭代器
* **返回一个迭代器**，从此位置开始有**连续的**`count`个相等元素，每个元素的值都和`val`相等。
* 如果序列中不存在这样的子序列，返回`end`。
* 第一个算法用`'=='`运算符判断两个元素是否相等。第二个算法用谓词判断两个元素是否相等。
* **注意**：算法既要比较序列中的两个相邻元素是否相等，又要比较这两个元素各自是否和`val`相等，因此每两个元素至少要比较两到三次。

### **查找子序列的算法**

这些算法中除了`find_first_of`之外，都要求两个前向迭代器。`find_first_of`用输入迭代器表示第一个序列，用前向迭代器表示第二个序列。这些算法搜索子序列而不是单个元素。

>`search(beg1, end1, beg2, end2)`  
`search(beg1, end1, beg2, end2, binaryPred)`

* 要求两个前向迭代器。
* **返回一个迭代器**，指向第二个输入范围（子序列）在第一个输入范围中第一次出现的位置。如果未找到子序列，则返回`end1`。
* `binaryPred`用来比较两个元素是否相等。

>`find_first_of(beg1, end1, beg2, end2)`  
`find_first_of(beg1, end1, beg2, end2, binaryPred)`

* 第一个输入范围要求输入迭代器，第二个输入范围要求前向迭代器。
* **返回一个迭代器**，指向第二个输入范围（子序列）中任意元素在第一个输入范围中第一次出现的位置。如果未找到匹配元素，则返回`end1`。

>`find_end(beg1, end1, beg2, end2)`  
`find_end(beg1, end1, beg2, end2, binaryPred)`

* 类似`search`，但返回的是最后一次出现的位置。未找到则返回`end1`。

## 其他只读算法

这些算法要求输入迭代器。

>`for_each(beg, end, unaryOp)`

* 要求输入迭代器。
* 对每个元素调用`unaryOp`，注意`unaryOp`是个可调用对象，不是谓词。忽略`unaryOp`的返回值。如果迭代器允许的话，可以在`unaryOp`里修改元素。

>`mismatch(beg1, end1, beg2)`  
`mismatch(beg1, end1, beg2, binaryPred)`

* 要求输入迭代器。
* 比较两个序列中的元素。**返回一个`pair<iter1, iter2>`类型**（`pair`在头文件`utility`中），`pair`中保存了两个迭代器，表示两个序列各自的第一个不匹配元素。如果所有元素都匹配，则`iter1`指向`end1`，`iter2`指向第二个序列中偏移量等于`end1`-`beg1`的位置。
* 显然，这里的“所有元素都匹配”指的是第二个序列的前半部分和第一个序列完全匹配。

>`equal(beg1, end1, beg2)`  
`equal(beg1, end1, beg2, binaryPred)`

* 要求输入迭代器。
* 返回一个`bool`类型的值。算法检查两个序列是否相等。相等就返回`true`。
* **注意**，如果第二个序列比第一个长的话，这个算法只会比较第二个序列的前半部分是否和第一个序列相同，相同就返回`true`。这个算法还有一个带`end2`参数的版本，这个算法在上面这种情况下会返回`false`。

## 二分搜索算法

这些算法都要求前向迭代器，但这些算法仅过了优化，如果提供了随机访问迭代器，算法的性能会好很多。  
**这些算法要求序列中的元素已经是有序的(这里的“有序”是指元素按从小到大排列)**。  
每个算法提供两个版本：第一个版本用`"<"`运算符比较元素；第二个版本用`comp`比较元素。

>`lower_bound(beg, end, val)`  
`lower_bound(beg, end, val, comp)`

* 要求前向迭代器。
* **返回一个迭代器**，指向第一个不小于（大于等于）`val`的元素，如果不存在这样的元素，则返回`end`。

>`upper_bound(beg, end, val)`  
`upper_bound(beg, end, val, comp)`

* 要求前向迭代器。
* **返回一个迭代器**，指向第一个大于（没有等于）`val`的元素，如果不存在这样的元素，则返回`end`。
* **注意：`lower_bound`希望将元素插入到相同元素的前面，因而返回的迭代器指向的元素不小于插入元素，而`upper_bound`相反，它希望将元素插入到相同元素的后面，因而返回的迭代器指向的元素大于插入元素**。

>`equal_range(beg, end, val)`  
`equal_range(beg, end, val, comp)`

* 要求前向迭代器。
* **返回一个`pair<iter1, iter2>`**，其中`iter1`是`lower_bound`返回的迭代器，`iter2`是`upper_bound`返回的迭代器。

>`binary_search(beg, end, val)`  
`binary_search(beg, end, val, comp)`

* 要求前向迭代器。
* 返回一个bool值，指出序列中是否包含`val`。

## 写容器的算法

### **只写不读元素的算法**

这些算法要求一个输出迭代器，表示目的位置，`_n`的版本接受第二个实参，表示写入的元素数目。

>`fill(beg, end, val)`  
`fill_n(dest, cnt, val)`

* 要求输出迭代器
* 给序列中每个元素赋新值`val`。
* `fill`返回`void`，**`fill_n`返回一个迭代器**，指向最后一个写入元素之后的位置。

>`generate(beg, end, gen)`  
`generate(dest, cnt, gen)`

* 要求输出迭代器。
* 与`fill`不同，`generate`用可调用对象`gen`生成新值，**`gen`的返回值和容器中元素的类型相同，并且`gen`不需要用序列中的元素作为参数**。
* `gen`返回`void`，**`gen_n`返回一个迭代器**，指向最后一个写入元素之后的位置。

### 使用输入迭代器的写算法

这些算法读取一个输入序列，将值写到一个输出序列中。要求两个表示范围的输入迭代器和一个输出迭代器。

>`copy(beg, end, dest)`  
`copy_if(beg, end, dest, unaryPred)`  
`copy_n(beg, n, dest)`

* 要求输入迭代器和输出迭代器。
* `copy_if`拷贝满足条件的元素。
* 返回值？

>`move(beg, end, dest)`

* 要求输入迭代器和输出迭代器。
* 对输入序列的每个元素调用`std::move`（见13.3.1节，第472页），将其移动到`dest`开始的序列中。

>`transform(beg, end, dest, unaryOp)`  
`transform(beg, end, beg2, dest, binaryOp)`

* 要求输入迭代器和输出迭代器。
* 第一个版本对序列中所有元素调用`unaryOp`，并将结果写到`dest`中；第二个版本对两个序列中的元素应用`binaryOp`。

>`replace_copy(beg, end, dest, old_val, new_val)`  
`replace_copy_if(beg, end, dest, unaryPred, new_val)`

* 要求输入迭代器和输出迭代器。
* 将每个元素拷贝到`dest`，将指定的元素替换为`new_val`。

>`merge(beg1, end1, beg2, end2, dest)`  
`merge(beg1, end1, beg2, end2, dest, comp)`

* 要求输入迭代器和输出迭代器。
* 两个输入序列必须是有序的。
* 第一个版本用`"<"`运算符比较元素，第二个版本用`comp`比较元素。

### **使用前向迭代器的写算法**

这些算法要求前向迭代器，**向输入序列中写入元素**。

>`iter_swap(iter1, iter2)`

* 要求前向迭代器。
* 交换`iter1`和`iter2`指向的元素的值（只交换这两个元素，不交换序列）。
* 返回`void`。

>`swap_ranges(beg1, end1, beg2)`

* 要求前向迭代器。
* 将两个范围内的所有元素进行交换，**两个范围不能有重叠**。
* **返回一个迭代器**，指向第二个序列最后一个被交换元素之后的位置。

>`replace(beg, end, old_val, new,val)`  
`replace_if(beg, end, unaryPred, new,val)`

* 原址替换。

### **使用双向迭代器的写算法**

这些算法要求双向迭代器。

>`copy_backward(beg, end, dest)`  
`move_backward(beg, end, dest)`

* 要求双向迭代器。
* 从输入范围中拷贝或移动元素到指定目的位置。
* **`dest`是输出序列的尾后迭代器（注意不是反向迭代器）**。
* 如果范围为空，则返回`dest`；否则，返回值指向从`*beg`拷贝或移动的元素（而不是`beg`的前一个位置）。

>`inplace_merge(beg, mid, end)`  
`inplace_merge(beg, mid, end, comp)`

* 要求双向迭代器。
* 将同一个序列的两个（相邻的）**有序**子序（**都是递增序列**）合并为单一的**有序**序列。`beg`到`mid`间的子序列和`mid`到`end`间的子序列被合并，并被写入到原序列中。第一个版本使用`“<”`运算符比较元素，第二个版本使用`comp`比较元素。
* 返回`void`。

## 划分与排序算法

每个排序和划分算法都提供稳定和不稳定版本。

### **划分算法**

划分算法将元素划为两组，**第一组元素满足给定谓词，第二组不满足。**  
这些算法都要求双向迭代器。

>`is_partitioned(beg, end, unaryPred)`

* 要求双向迭代器。
* 检查输入序列是否已经划分好。返回一个`bool`值。如果序列为空，返回`true`。

>`partition_copy(beg, end, dest1, dest2, unaryPred)`

* 要求双向迭代器。
* 将满足`unaryPred`的元素拷贝到`dest1`，不满足的元素拷贝到`dest2`。
* **返回一个`pair<iter1, iter2>`值**，`iter1`指向`dest1`序列的末尾（应该指的是尾后），`iter2`指向`dest2`序列的末尾。
* **输入序列和两个目的序列不能有重叠。**

>`partition_point(beg, end, unaryPred)`

* 要求双向迭代器。
* 输入序列必须是已经用`unaryPred`划分过了。**返回满足`unaryPred`部分的尾后迭代器**。

>`stable_partition(beg, end, unaryPred)`  
`partition(beg, end, unaryPred)`

* 要求双向迭代器。
* 使用`unaryPred`划分序列。一个是稳定划分，一个不是稳定划分。
* **返回满足`unaryPred`部分的尾后迭代器**。

>`nth_element(beg, nth, end)`  
`nth_element(beg, nth, end, comp)`

* 要求随机访问迭代器。
* 参数`nth`是一个迭代器，指向输入序列中的一个位置。划分结束后，这个位置上的新元素之前的元素均小于等于它，之后的元素均大于等于它。
* 这个算法与快速排序的划分算法有很大区别。快速排序的划分算法是这样，选择一个元素，把这个元素放到它最终该在的位置；而`nth_element`这个算法是选择一个位置，把最终该在这个位置上的元素放到这里来。

### **排序算法**

这些算法要求随机访问迭代器。每个排序算法提供两个重载版本，一个版本用`"<"`运算符来比较元素，另一个版本用`comp`比较元素。`partial_sort_copy`返回一个指向目的位置的迭代器，其他排序算法（本节还有不排序的算法）都返回`void`。

>`sort(beg, end)`  
`stable_sort(beg, end)`  
`sort(beg, end, comp)`  
`stable_sort(beg, end, comp)`

* 要求随机访问迭代器。
* 排序整个范围。返回`void`。
* 元素个数较少时，sort会使用插入排序算法；元素个数较多时，sort会使用快速排序算法，并且排序的过程中会调用元素自定义的swap函数交换元素（如果有的话）。

>`is_sorted(beg, end)`  
`is_sorted(beg, end, comp)`  
`is_sorted_until(beg, end)`  
`is_sorted_until(beg, end, comp)`

* 要求随机访问迭代器。
* `is_sorted`返回`bool`值，指出整个序列是否有序。
* `is_sorted_until`在输入序列中查找最长的有序子序列。**返回一个迭代器**，指向最长有序子序列的尾后位置。

>`partial_sort(beg, mid, end)`  
`partial_sort(beg, mid, end, comp)`

* 要求随机访问迭代器。
* 从序列中找出最小的`mid-beg`个元素，将这些元素有序地放在序列最前面，未排序区域的元素顺序是未知的。（注意这个算法不是只排序前`mid-beg`个元素，只排一部分元素使用`sort`算法就可以）

>`partial_sort_copy(beg, end, destBeg, destEnd)`  
`partial_sort_copy(beg, end, destBeg, destEnd, comp)`

* 要求随机访问迭代器。
* 排序整个输入序列，将排序结果拷贝到目的范围中。如果目的范围大于等于输入范围，则将整个输出序列拷贝到目的范围。如果目的范围比输入范围小，则只把输出序列中和目的范围一样多的元素拷贝到目的范围。
* **返回一个迭代器**，指向目的范围中输出序列的尾后元素。

## 通用重排操作

### **使用前向迭代器的重排算法**

>`remove(beg, end, val)`  
`remove_if(beg, end, unaryPred)`  
`remove_copy(beg, end, val)`  
`remove_copy_if(beg, end, unaryPred)`

* 要求前向迭代器。
* 从序列中“删除元素”。通过移动元素来完成删除，使得不被删除得元素出现在容器的前头，并且保留元素的相对顺序。
* 返回一个迭代器，指向新范围的尾后位置。新的尾后位置和旧的尾后位置之间的值是未知的（无意义的）。
* 该算法通常和容器的`erase`算法相配合使用。

>`unique(beg, end)`  
`unique(beg, end, binaryPred)`  
`unique_copy(beg, end, dest)`  
`unique_copy_if(beg, end, dest, binaryPred)`

* 要求前向迭代器。
* 对于序列中每组连续的（相邻的）相等元素，保留第一个元素，删掉后面的元素。用覆盖的方法删除，保留元素的相对顺序。
* 返回一个迭代器，指向不重复元素的尾后位置。新的尾后位置和旧的尾后位置之间的值是未知的（无意义的）。

>`rotate(beg, mid, end)`  
`rotate_copy(beg, mid, end, dest)`

* 要求前向迭代器。
* 把输入序列的前后两个部分颠倒顺序，`mid`是分割点。如{2，3，4，5，7，8，9，10}变为{7，8，9，10，2，3，4，5}，分割点是7。
* 返回一个迭代器，指向重排前序列的第一个元素在重排后的位置。上面的例子中，会返回2所在的位置。

### 使用双向迭代器的重排算法

这些算法要反向处理输入序列，它们要求双向迭代器。

>`reverse(beg, end)`  
`reverse_copy(beg, end, dest)`

* 要求双向迭代器。
* 翻转序列中的元素。`reverse`返回`void`，`reverse_copy`返回一个迭代器，指向目的序列的尾后元素。

### 使用随机访问迭代器的重排算法

>`random_shuffle(beg, end)`  
`random_shuffle(beg, end, rand)`  
`shuffle(beg, end, Uniform_rand)`

* 要求随机访问迭代器。
* 混洗输入序列中的元素。第二个版本的参数`rand`是一个可调用对象，该对象必须接受一个正整数，并生成0到此值的包含区间内的一个服从均匀分布的随机整数。`shuffle`的第三个参数必须满足均匀分布随机数生成器的要求（参见17.4节，第659页）。所有版本都返回`void`。

## (全)排列算法

排列算法生成序列的字典序排列。考虑下面这三个字符的序列abc，它有六种可能的排列：abc、acb、bac、bca、cab、cba。这些排列是按字典序递增排序的。

排列算法返回一个`bool`值，指出一个输入序列是否有下一个或前一个排列。这些算法假定序列中的元素都是唯一的，即，没有两个元素的值是一样的。算法要求双向迭代器。

>`is_permutation(beg1, end1, beg2)`  
`is_permutation(beg1, end1, beg2, binaryPred)`

* 要求双向迭代器。
* 如果第二个序列的某个排列和第一个序列具有相同数目的元素，且元素都相等。则返回`true`。第一个版本用`“==”`运算符比较元素，第二个版本用`binaryPred`比较元素。
* **这里有个问题，`binaryPred`是仅用来在两个序列间比较元素还是也会用在序列内部的元素比较上？（从直觉上来看应该是仅用来在两个序列间比较元素。原因是`binaryPred`是用来代替`“==”`运算符的，而光用`“==”`运算符是无法对序列进行字典序排序的。但如果类没有重载`“==”`运算符时算法依然能正常运行，说明`binaryPred`是用来比较所有元素的）**

>`next_permutation(beg, end)`  
`next_permutation(beg, end, comp)`

* 要求双向迭代器。
* 如果序列已经是最后一个排列，则`next_permutation`将排列重排为最小的排列（第一个排列），并返回`false`。否则，它将输入序列转换为字典序的下一个排列，并返回`true`。
* 第一个版本用`“<”`运算符比较元素，第二个版本用给定的比较操作。

>`prev_permutation(beg, end)`  
`prev_permutation(beg, end, comp)`

* 功能和上面两个函数相反。

## 有序序列的集合算法

集合算法实现了有序序列上的一般集合操作。这些算法与标准库`set`容器不同，不要与`set`上的操作相混淆。

这些算法要求输入迭代器。**返回递增后的`dest`迭代器，表示写入`dest`的最后一个元素之后的位置**。

**每种算法都有两个重载版本，第一个版本使用`“<”`运算符比较元素，第二个版本使用给定的比较操作**。

>`include(beg, end, beg2, end2)`  
`include(beg, end, beg2, end2, comp)`

* 要求两组输入迭代器。
* 如果第二个序列中每个元素都包含在输入序列中，返回`true`。否则返回`false`。
* B⊆A

>`set_intersection(beg, end, beg2, end2, dest)`  
`set_intersection(beg, end, beg2, end2, dest, comp)`

* 要求两组输入迭代器和一个输出迭代器。
* 对两个序列中的所有元素，创建它们的有序序列。如果某个元素e在第一个序列中出现了m次，在第二个序列中出现了n次，那么将第一个序列中的前min{m, n}个元素拷贝到目的序列，保留元素间的相对顺序。
* A∩B

>`set_union(beg, end, beg2, end2, dest)`  
`set_union(beg, end, beg2, end2, dest, comp)`

* 对两个序列中的所有元素，创建它们的有序序列。如果某个元素e在第一个序列中出现了m次，在第二个序列中出现了n次，那么将max{m, n}个元素拷贝到目的序列，保留元素间的相对顺序。这个max{m, n}个元素先从第一个序列中拷贝，第一个序列的元素不够用时再从第二个序列中拷贝。
* A∪B

>`set_difference(beg, end, beg2, end2, dest)`  
`set_difference(beg, end, beg2, end2, dest, comp)`

* 对出现在第一个序列中，但不在第二个序列中的元素，创建一个有序序列。
* A-B

>`set_symmetric_difference(beg, end, beg2, end2, dest)`  
`set_symmetric_difference(beg, end, beg2, end2, dest, comp)`

* 对那些只出现在一个序列，不在另外一个序列中的元素，创建一个有序序列。
* A∪B-A∩B

## 最小值和最大值

这些算法使用`“<”`运算符比较元素。第一组算法对值进行操作，第二组算法对序列进行操作。要求输入迭代器。

>`min(val1, val2)`  
`min(val1, val2, comp)`  
`min(init_list)`  
`min(init_list, comp)`  

>`max(val1, val2)`  
`max(val1, val2, comp)`  
`max(init_list)`  
`max(init_list, comp)`  

* 返回最小值/最大值。参数都是`const`的引用。
* **注意：第二组算法需要一个容器作为参数，而不是迭代器**。

>`minmax(val1, val2)`  
`minmax(val1, val2, comp)`  
`minmax(init_list)`  
`minmax(init_list, comp)`

* 返回一个`pair`，它的第一个成员是最小值，第二个成员是最大值。

>`min_element(beg, end)`  
`min_element(beg, end, comp)`  
`max_element(beg, end)`  
`max_element(beg, end, comp)`  
`minmax_element(beg, end)`  
`minmax_element(beg, end, comp)`

* 需要迭代器作为参数。
* 前四个算法返回最大值/最小值。
* 后两个算法返回`pair`。

### 字典序比较

>`lexicographical_compare(beg1, end1, beg2, end2)`  
`lexicographical_compare(beg1, end1, beg2, end2, comp)`

* 算法比较两个序列，根据第一对不相等的元素来返回结果。算法使用`“<”`运算符或`comp`比较元素。
* 如果序列1在字典序中小于序列2，则返回`true`，否则返回`false`。

### 数值算法

>`accumulate(beg, end, init)`  
`accumulate(beg, end, init, binaryOp)`

* 算法求输入序列的元素之和，`init`为初值，`binaryOp`代替了`“+”`运算符。

>`inner_product(beg1, end1, beg2, init)`  
`inner_product(beg1, end1, beg2, init, binOp1, binOp2)`

* 返回两个序列的内积。和的初值由`init`指定，`init`的类型确定了返回值的类型。`binOp1`代替加法，`binOp2`代替乘法。

>`partial_sum(beg, end, dest)`
`partial_sum(beg, end, dest, binaryOp)`

* 将新序列写到`dest`中，新序列中的每个元素都是输入序列中当前位置上的前缀和（包括当前位置）。用`binaryOp`代替`“+”`运算符。返回一个迭代器，指向输出序列的尾后位置。

>`adjacent_difference(beg, end, dest)`  
`adjacent_difference(beg, end, dest, bianryOp)`

* 将新序列写入`dest`，每个新元素的值都等于当前位置和前一个位置元素只差。用`binaryOp`代替`“-”`运算符。

>`iota(beg, end, val)`

* 将`val`值赋予首元素并递增`val`，将递增后的值赋予下一个元素。使用前置的`“++”`运算符递增`val`。

