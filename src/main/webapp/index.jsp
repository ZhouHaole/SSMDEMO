<%--
  Created by IntelliJ IDEA.
  User: 52437
  Date: 2022/3/20
  Time: 17:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>员工列表</title>
    <%--web路径
        不以/开始的相对路径找资源,以当前资源的路径为基准,疆场容易出问题
        以/开始的相对路径找资源,以服务器路径为标准(http://localhost:3306/),需要加上项目名
    --%>
    <%
        pageContext.setAttribute("APP_Path",request.getContextPath());
    %>
    <%--引入jq--%>
    <%--<script type="text/javascript" src="${APP_Path}/static/bootstrap-3.4.1-dist/js/jquery-1.7.2.js"></script>--%>
    <script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
    <%--引入bootstrap样式--%>
    <link href="${APP_Path}/static/bootstrap-3.4.1-dist/css/bootstrap.min.css" rel="stylesheet">
    <script type="text/javascript" src="${APP_Path}/static/bootstrap-3.4.1-dist/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        var pages;
        var pageNum;
    <%--页面加载完成后,发送ajax请求得到分页数据--%>
        $(function () {
            //去第1页
            to_Page(1);
        })

        function to_Page(pn) {
            $.ajax({
                url:"${APP_Path}/emps",
                data:"pn="+pn,
                type:"GET",
                success:function (result) {
                    //1.解析并显示员工数据
                    build_EmpTable(result);
                    //2.解析并显示分页信息
                    build_Page_Data(result);
                    //3.解析并显示分页条
                    build_Pagehelper(result);

                }
            })
        }
        //员工表格
        function build_EmpTable(result) {
            //清空之前数据
            $("#tbody").empty()
            var emps=result.extend.pageInfo.list;
            $.each(emps,function (index,item) {
                var checkBoxId=$("<td><input class='check_Box' type='checkbox'></td>");
                var empId=$("<td></td>").append(item.empId);
                var empName=$("<td></td>").append(item.empName);
                var email=$("<td></td>").append(item.email);
                var gender=$("<td></td>").append(item.gender);
                var deptName=$("<td></td>").append(item.dept.deptName);
                var editBtn=$("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                            .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
                    editBtn.attr("editId",item.empId);
                var deleteBtn=$("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
                    deleteBtn.attr("deleteId",item.empId);
                $("<tr></tr>").append(checkBoxId).append(empId).append(empName).append(email)
                              .append(gender).append(deptName).append($("<td></td>").append(editBtn).append(deleteBtn))
                              .appendTo("#tbody");
            })
        }
        //分页信息
        function build_Page_Data(result) {
            //清空之前数据
            $("#data").empty()
            $("#data").append("当前第"+result.extend.pageInfo.pageNum+"页，总共有"+
                             result.extend.pageInfo.pages+"页，总共有"+
                                result.extend.pageInfo.total+"条数据");
            pages= result.extend.pageInfo.pages;
            pageNum=result.extend.pageInfo.pageNum;
        }
        //分页条
        function build_Pagehelper(result) {
            //清空之前数据
            $("#ul").empty()
            var ul=$("#ul");
            var firstPage=$("<li></li>").append($("<a></a>").append("首页"));
            var prePage=$("<li></li>").append($("<a></a>").append("&laquo;"));
            firstPage.click(function () {
                to_Page(1);
            })
            prePage.click(function () {
                to_Page(result.extend.pageInfo.pageNum-1);
            })
            var nextPage=$("<li></li>").append($("<a></a>").append("&raquo;"));
            var lastPage=$("<li></li>").append($("<a></a>").append("末页"));
            lastPage.click(function () {
                to_Page(result.extend.pageInfo.pages);
            })
            nextPage.click(function () {
                to_Page(result.extend.pageInfo.pageNum+1);
            })

            ul.append(firstPage);
            if (result.extend.pageInfo.hasPreviousPage){
                ul.append(prePage);
            }

            $.each(result.extend.pageInfo.navigatepageNums,function (index,item){
                var numLi=$("<li></li>").append($("<a></a>").append(item));
                if (result.extend.pageInfo.pageNum==item){
                    numLi.addClass("active");
                }
                numLi.click(function () {
                    to_Page(item);
                })
                ul.append(numLi);
            });
            if (result.extend.pageInfo.hasNextPage){
                ul.append(nextPage)
            }
                ul.append(lastPage);
        }
    </script>

</head>
<body>

<!-- 员工添加模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <%--表单--%>
                <form class="form-horizontal" id="addForm">
                    <div class="form-group">
                        <label for="inputEmpName" class="col-sm-2 control-label">EmpName</label>
                        <div class="col-sm-10">
                            <input type="email" class="form-control" id="inputEmpName" placeholder="请输入员工姓名" name="empName">
                            <span id="helpBlock2" class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputEmail" class="col-sm-2 control-label">Email</label>
                        <div class="col-sm-10">
                            <input type="email" class="form-control" id="inputEmail" placeholder="请输入员工邮箱" name="email">
                            <span id="helpBlock3" class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" class="gender" value="男" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" class="gender" value="女"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">DeptName</label>
                        <div class="col-sm-4">
                            <select class="form-control" id="dept_add_Select" name="deptId">
                            </select>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>


<!-- 员工修改模态框 -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="UpdateLabel">员工修改</h4>
            </div>
            <div class="modal-body">
                <%--表单--%>
                <form class="form-horizontal" id="addForm">
                    <div class="form-group">
                        <label for="inputEmpName" class="col-sm-2 control-label">EmpName</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="EmpName_update"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputEmail" class="col-sm-2 control-label">Email</label>
                        <div class="col-sm-10">
                            <input type="email" class="form-control" id="UpdateEmail" placeholder="请输入员工邮箱" name="email">
                            <span id="helpBlock5" class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" class="gender" value="男" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" class="gender" value="女"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">DeptName</label>
                        <div class="col-sm-4">
                            <select class="form-control" id="dept_update_Select" name="deptId">
                            </select>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>
        </div>
    </div>
</div>

<%--搭建显示页面--%>
<div class="container">
    <%--标题--%>
    <div class="row">
        <div class="col-lg-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <%--按钮--%>
    <div class="row">
        <div class="col-md-2 col-md-offset-8">
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
        </div>
    </div>

        <%--新增按钮互动--%>
        <script>
            function reset_form(ele){
                $(ele)[0].reset();
                //清空表单样式
                $("*").removeClass("has-error has-success");
                $(".help-block").text("");
            }

            //如果绑定了事件模态框缺不弹出来,可能是jquery和bootstrap的版本不匹配
            $("#emp_add_modal_btn").click(function () {
                //表单重置
                reset_form("#empAddModal form");
                //发送ajax请求,查出部门信息显示在下拉列表中
                getDepts("#dept_add_Select");
                //弹出模态框
                $("#empAddModal").modal({
                    backdrop:"static"
                });
            })
            //查出所有部门信息在下拉列表中
            function getDepts(ele) {
                $(ele).empty();
                $.ajax({
                    url: "${APP_Path}/depts",
                    type: "GET",
                    success:function (result) {
                        $("#inputEmail").empty();
                        $.each(result.extend.depts,function () {
                            $(ele).append($("<option></option>").append(this.deptName).attr("value",this.deptId));
                        });
                    }
                })
            }

            //校验信息是否符合要求
            function Calibration(){
                // var empName=$("#inputEmpName").val();
                // //正则表达式
                // var regName=/(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5}$)/
                // if (!regName.test(empName)){
                //     Calibration_show("#inputEmpName","error","用户名格式不正确");
                //     return false;
                // }else {
                //     Calibration_show("#inputEmpName","success","")
                // }
                //邮箱验证
                var email=$("#inputEmail").val();
                var regMail=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
                if (!regMail.test(email)){
                    Calibration_show("#inputEmail","error","邮箱格式不正确");
                    return false;
                }else {
                    Calibration_show("#inputEmail","success","");
                }
                return true;
            }

            function Calibration_show(id,status,msg){
                //清楚当前元素的校验状态
                $(id).parent().removeClass("has-success has-error");
                if("success"==status){
                    $(id).parent().addClass("has-success");
                    $(id).next("span").text(msg)
                }else if(("error"==status)){
                    $(id).parent().addClass("has-error");
                    $(id).next("span").text(msg)
                }
            }

            $("#inputEmpName").change(function () {
                //检查用户名是否重名
                $.ajax({
                    url:"${APP_Path}/checkUser",
                    data:"empName="+$(this).val(),
                    type:"POST",
                    success:function (result) {
                        if (result.code==100){
                            Calibration_show("#inputEmpName","success","用户名可用");
                            $("#emp_save_btn").attr("ajax-va","success");
                        }else {
                            Calibration_show("#inputEmpName","error",result.extend.vg);
                            $("#emp_save_btn").attr("ajax-va","error");
                        }
                    }
                })
            })

            $("#emp_save_btn").click(function () {
                //要提交数据先进行表单校验
                // if (!Calibration()){
                //     return false;
                // }
                //用ajax判断用户名是否校验成功
                if ($(this).attr("ajax-va")=="error"){
                    return false;
                }
                $.ajax({
                    url:"${APP_Path}/empSave",
                    type:"POST",
                    //将表单数据变成字符串参数
                    data:$("#addForm").serialize(),
                    success:function (result) {
                        if (result.code==100) {
                            //保存成功关闭模态框
                            $("#empAddModal").modal("hide");
                            //并跳转到最后一页
                            to_Page(pages+1);
                        }else {
                            //显示失败信息
                            if(undefined!=result.extend.errorFields.empName){
                                Calibration_show("#inputEmpName","error","用户名格式不正确")
                            }
                            if(undefined!=result.extend.errorFields.email){
                                Calibration_show("#inputEmail","error","邮箱格式不正确")
                            }

                        }
                    }
                })
            })

        </script>

        <%--表格信息--%>
    <div class="row">
        <div class="col-lg-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                    <tr>
                        <th><input type="checkbox" id="checked_All"></th>
                        <th>#</th>
                        <th>Emp_name</th>
                        <th>email</th>
                        <th>gender</th>
                        <th>dept_name</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody id="tbody">

                </tbody>

            </table>
        </div>
    </div>

        <script>
            $(document).on("click",".delete_btn",function () {
                if (confirm("确认要删除该名员工吗?")){
                    $.ajax({
                        url:"${APP_Path}/delete/"+$(this).attr("deleteId"),
                        type:"DELETE",
                        success:function (result) {
                            alert(result.msg);
                            to_Page(pageNum);
                        }
                    })}
            })
            //打开员工修改模态框
            $(document).on("click",".edit_btn",function () {
                getDepts("#dept_update_Select");
                getEmp($(this).attr("editId"));
                $("#emp_update_btn").attr("edit_Id",$(this).attr("editId"));
                $("#empUpdateModal").modal({
                    backdrop: "static"
                })
            })

            function getEmp(id) {
                $.ajax({
                    url:"${APP_Path}/getEmp/"+id,
                    type:"GET",
                    success:function (result) {
                        $("#EmpName_update").text(result.extend.emp.empName);
                        $("#UpdateEmail").val(result.extend.emp.email);
                        $("#empUpdateModal input[name=gender]").val([result.extend.emp.gender]);
                        $("#empUpdateModal select").val(result.extend.emp.deptId);
                    }
                })
            }

            $("#emp_update_btn").click(function () {
                var email=$("#UpdateEmail").val();
                var regMail=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
                if (!regMail.test(email)){
                    Calibration_show("#inputEmail","error","邮箱格式不正确");
                    return false;
                }else {
                    Calibration_show("#inputEmail","success","");
                }
                $.ajax({
                    url:"${APP_Path}/updateEmp/"+$("#emp_update_btn").attr("edit_Id"),
                    type:"POST",
                    data:$("#empUpdateModal form").serialize()+"&_method=PUT",
                    success:function (result) {
                        alert(result.msg);
                        $("#empUpdateModal").modal("hide");
                        to_Page(pageNum);
                    }
                })
            })

            $("#checked_All").click(function () {
                //全选和全不选同步
                $(".check_Box").prop("checked", $(this).prop("checked"))
            })

            $(document).on("click",".check_Box",function () {
                //判断是否选满了,在把全选是否选上
                if($(".check_Box:checked").length==$(".check_Box").length){
                    $("#checked_All").prop("checked",true);
                }else {
                    $("#checked_All").prop("checked",false);
                }
            })

            $("#emp_delete_all_btn").click(function () {
                var empNames="";
                var empIds=""
                $.each($(".check_Box:checked"),function () {
                    empNames+=$(this).parents("tr").find("td:eq(2)").text()+",";
                    empIds+=$(this).parents("tr").find("td:eq(1)").text()+"-";
                })
                //去除多余,号
                empNames = empNames.substring(0,empNames.length-1);
                empIds = empIds.substring(0,empNames.length-1);
                if(confirm("是否要删除["+empNames+"]的信息")){
                    $.ajax({
                        url:"${APP_Path}/delete/"+empIds,
                        type:"DELETE",
                        success:function (result) {
                            alert(result.msg);
                            to_Page(pageNum);
                            $("#checked_All").prop("checked",false);
                        }
                    })
                }
            })
        </script>

    <%--分页--%>
    <div class="row">
        <%--分页信息--%>
        <div class="col-md-6 col-md-offset-4" id="data">

        </div>
        <%--分页条--%>
        <div class="col-md-6 col-md-offset-4">
            <nav aria-label="Page navigation">
                <ul class="pagination" id="ul">

                    <%--<c:forEach items="${pageInfo.navigatepageNums}" var="page_Num">--%>
                    <%--    <c:if test="${pageInfo.pageNum==page_Num}">--%>
                    <%--        <li class="active"><a href="#">${page_Num}</a></li>--%>
                    <%--    </c:if>--%>
                    <%--    <c:if  test="${pageInfo.pageNum!=page_Num}">--%>
                    <%--        <li><a href="${APP_Path}/emps?pn=${page_Num}">${page_Num}</a></li>--%>
                    <%--    </c:if>--%>

                    <%--</c:forEach>--%>
                </ul>
            </nav>
        </div>
    </div>
</div>

</body>
</html>