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
    <script type="text/javascript" src="${APP_Path}/static/bootstrap-3.4.1-dist/js/jquery-1.7.2.js"></script>
    <%--引入bootstrap样式--%>
    <link href="${APP_Path}/static/bootstrap-3.4.1-dist/css/bootstrap.min.css" rel="stylesheet">
    <script type="text/javascript" src="${APP_Path}/static/bootstrap-3.4.1-dist/js/bootstrap.min.js"></script>
</head>
<body>
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
            <div class="col-md-4 col-md-offset-8">
                <button class="btn btn-primary">新增</button>
                <button class="btn btn-danger">删除</button>
            </div>
        </div>
        <%--表格信息--%>
        <div class="row">
            <div class="col-lg-12">
                <table class="table">
                    <tr>
                        <th>#</th>
                        <th>Emp_name</th>
                        <th>email</th>
                        <th>gender</th>
                        <th>dept_name</th>
                        <th>操作</th>
                    </tr>
                    <c:forEach items="${pageInfo.list}" var="emp">
                        <tr>
                            <th>${emp.empId}</th>
                            <th>${emp.empName}</th>
                            <th>${emp.email}</th>
                            <th>${emp.gender}</th>
                            <th>${emp.dept.deptName}</th>
                            <th>
                                <button class="btn btn-primary btn-sm"><span class="glyphicon glyphicon-pencil"/>编辑</button>
                                <button class="btn btn-danger btn-sm"><span class="glyphicon glyphicon-trash"/>删除</button>
                            </th>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </div>
        <%--分页--%>
        <div class="row">
            <%--分页信息--%>
            <div class="col-md-6 col-md-offset-4">
                当前第${pageInfo.pageNum}页，总共有${pageInfo.pages}页，总共有${pageInfo.total}条数据
            </div>
            <%--分页条--%>
            <div class="col-md-6 col-md-offset-4">
                <nav aria-label="Page navigation">
                    <ul class="pagination">

                        <li><a href="${APP_Path}/emps?pn=1">首页</a></li>
                        <c:if test="${pageInfo.hasPreviousPage}">
                            <li>
                                <a href="${APP_Path}/emps?pn=${pageInfo.pageNum-1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>

                        <c:forEach items="${pageInfo.navigatepageNums}" var="page_Num">
                            <c:if test="${pageInfo.pageNum==page_Num}">
                                <li class="active"><a href="#">${page_Num}</a></li>
                            </c:if>
                            <c:if  test="${pageInfo.pageNum!=page_Num}">
                                <li><a href="${APP_Path}/emps?pn=${page_Num}">${page_Num}</a></li>
                            </c:if>

                        </c:forEach>
                        <c:if test="${pageInfo.hasNextPage}">
                        <li>
                            <a href="${APP_Path}/emps?pn=${pageInfo.pageNum+1}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                        </c:if>
                        <li><a href="${APP_Path}/emps?pn=${pageInfo.pages}">末页</a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
    <%----%>
</body>
</html>