import 'package:expense_tracker/screens/add_expense/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker/screens/add_expense/presentation/widgets/save_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future getCategoryCreation(BuildContext context) {
  List<String> myCategoriesIcons = [
    'entertainment',
    'food',
    'home',
    'pet',
    'shopping',
    'tech',
    'travel',
  ];
  return showDialog(
    context: context,
    builder: (ctx) {
      String selectedIcon = '';
      late Color categoryColor = Colors.white;
      bool isExpanded = false;
      TextEditingController categoryNameController = TextEditingController();
      bool isLoading = false;
      Category category = Category.empty;

      return BlocProvider.value(
        value: context.read<CreateCategoryBloc>(),

        child: StatefulBuilder(
          builder: (context, setState) {
            return BlocListener<CreateCategoryBloc, CreateCategoryState>(
              listener: (context, state) {
                if (state is CreateCategorySuccess) {
                  Navigator.pop(ctx, category);
                } else if (state is CreateCategoryLoading) {
                  setState(() {
                    isLoading == true;
                  });
                }
              },
              child: AlertDialog(
                backgroundColor: Colors.blueGrey[100],
                title: Center(
                  child: Text(
                    'Create a Category',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                ),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: categoryNameController,
                        decoration: InputDecoration(
                          filled: true,
                          isDense: true,

                          fillColor: Colors.white,
                          hintText: 'Name',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),

                      TextFormField(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          filled: true,
                          isDense: true,
                          suffixIcon: Icon(
                            CupertinoIcons.chevron_down,
                            size: 12,
                            color: Colors.grey,
                          ),
                          fillColor: Colors.white,
                          hintText: 'Icon',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: isExpanded
                                ? BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  )
                                : BorderRadius.circular(30.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      isExpanded
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(12.r),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0.w),
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 5,
                                      ),
                                  itemCount: myCategoriesIcons.length,
                                  itemBuilder: (context, int i) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIcon = myCategoriesIcons[i];
                                        });
                                      },
                                      child: Container(
                                        height: 20.h,
                                        width: 20.w,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2,
                                            color:
                                                selectedIcon ==
                                                    myCategoriesIcons[i]
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                          image: DecorationImage(
                                            image: AssetImage(
                                              'assets/${myCategoriesIcons[i]}.png',
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(height: 15.h),

                      TextFormField(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx2) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ColorPicker(
                                      pickerColor: categoryColor,
                                      onColorChanged: (value) {
                                        setState(() {
                                          categoryColor = value;
                                        });
                                      },
                                    ),
                                    SaveButton(
                                      onPressed: () {
                                        Navigator.pop(ctx2);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          filled: true,
                          isDense: true,

                          fillColor: categoryColor,
                          hintText: 'Color',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      SaveButton(
                        isloading: isLoading,
                        onPressed: () {
                          setState(() {
                            category.categoryId = Uuid().v1();
                            category.icon = selectedIcon;
                            category.color = categoryColor.value;
                            category.name = categoryNameController.text;
                          });

                          context.read<CreateCategoryBloc>().add(
                            CreateCategory(category),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
