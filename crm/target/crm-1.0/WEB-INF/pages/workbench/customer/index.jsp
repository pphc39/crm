<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">

<link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">

	$(function(){

		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		queryCustomerByConditionsForPage(1, 10);

		$("#query-owner").keyup(function (){
			queryCustomerByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'))
		});

		$("#query-name").keyup(function (){
			queryCustomerByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'))
		});

		$("#query-phone").keyup(function (){
			queryCustomerByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'))
		});

		$("#query-website").keyup(function (){
			queryCustomerByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'))
		});

		$("#queryCustomerBtn").click(function (){
			queryCustomerByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'))
		});

        $("#checkAll").click(function (){
            $("#tBody input[type='checkbox']").prop("checked", this.checked)
        });

        $("#tBody").on("click", "input[type='checkbox']", function (){
            if($("#tBody input[type='checkbox']").size()==$("#tBody input[type='checkbox']:checked").size()){
                $("#checkAll").prop("checked", true);
            }else {
                $("#checkAll").prop("checked", false);
            }
        });

		$("#createCustomerBtn").click(function (){
			$("#createCustomerForm").get(0).reset();
			$("#createCustomerModal").modal("show");
		});

		$("#create-customerName").change(function (){
			var name = $.trim(this.value);
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/customer/judgeCustomerExist',
				data:{name:name},
				type:'post',
				dataType:'json',
				success:function (returnObj){
					if(returnObj.flag=="yes"){
						alert(returnObj.message);
						$("#create-customerName").val("");
					}
				}
			});
		});

		$("#saveCreateCustomerBtn").click(function (){
			var owner = $("#create-customerOwner").val();
			var name = $.trim($("#create-customerName").val());
			var website = $.trim($("#create-website").val());
			var phone = $.trim($("#create-phone").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime = $("#create-nextContactTime").val();
			var description = $.trim($("#create-description").val());
			var address = $.trim($("#create-address").val());
			if(formJudge(owner, name, website, phone) == "false"){
                return;
            }
		// 	if(owner ==""){
		// 	alert("‘所有者’不能为空！");
		// 	return;
		// };
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/customer/saveCreateCustomer',
				data:{owner:owner, name:name, website:website, phone:phone, contactSummary:contactSummary, nextContactTime:nextContactTime, description:description, address:address},
				type:'post',
				dataType:'json',
				success:function (returnObj){
					if(returnObj.flag=="1"){
						queryCustomerByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
						$("#createCustomerModal").modal("hide");
					}else {
						alert(returnObj.message);
						$("#createCustomerModal").modal("show");
					}
				}
			});
		});

		$("#editCustomerBtn").click(function (){
			var checkedObj = $("#tBody input[type='checkbox']:checked");
			if(checkedObj.size()==0){
				alert("请选择要修改的客户！");
				return;
			}
			if(checkedObj.size()>1){
				alert("每次只能修改一条客户信息！");
				return;
			}
			var id = checkedObj.val();
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/customer/queryCustomerById',
				data:{id:id},
				type:'post',
				dataType:'json',
				success:function (customer){
					$("#edit-customerId").val(customer.id);
					$("#edit-customerOwner").val(customer.owner);
					$("#edit-customerName").val(customer.name);
					$("#edit-website").val(customer.website);
					$("#edit-phone").val(customer.phone);
					$("#edit-description").val(customer.description);
					$("#edit-contactSummary").val(customer.contactSummary);
					$("#edit-nextContactTime").val(customer.nextContactTime);
					$("#edit-address").val(customer.address);
					$("#editCustomerModal").modal("show");
				}
			});
		});

		$("#saveEditCustomer").click(function (){
			var id = $("#edit-customerId").val();
			var owner = $("#edit-customerOwner").val();
			var name = $("#edit-customerName").val();
			var website = $("#edit-website").val();
			var phone = $("#edit-phone").val();
			var description = $("#edit-description").val();
			var contactSummary = $("#edit-contactSummary").val();
			var nextContactTime = $("#edit-nextContactTime").val();
			var address = $("#edit-address").val();
			if(formJudge(owner, name, website, phone)=="false"){
				return;
			}
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/customer/saveEditCustomer',
				data:{id:id, owner:owner, name:name, website:website, phone:phone, description:description, contactSummary:contactSummary, nextContactTime:nextContactTime, address:address},
				type:'post',
				dataType:'json',
				success:function (returnObj){
					if(returnObj.flag=="1"){
						queryCustomerByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
						$("#editCustomerModal").modal("hide");
					}else {
						alert(returnObj.message);
						$("#editCustomerModal").modal("show");
					}
				}
			});
		});

	});

	function queryCustomerByConditionsForPage(pageNo, pageSize){
		var owner = $("#query-owner").val();
		var name = $("#query-name").val();
		var phone = $("#query-phone").val();
		var website = $("#query-website").val();
		// var pageNo = 1;
		// var pageSize = 10;
		$.ajax({
			url:'${pageContext.request.contextPath}/workbench/customer/queryCustomerByConditionsForPage',
			data:{owner:owner, name:name, phone:phone, website:website, pageNo:pageNo, pageSize:pageSize},
			type:'post',
			dataType: 'json',
			success:function (returnMap){
				// $("#activityCount").text(returnMap.activityCount)
				//计算总页数
				var totalPages = 0;
				if(returnMap.customerCount % pageSize == 0){
					totalPages = returnMap.customerCount/pageSize;
				}else {
					totalPages = parseInt(returnMap.customerCount/pageSize) + 1;
				}

				$("#pagination").bs_pagination({
					currentPage: pageNo,

					rowsPerPage: pageSize,
					totalRows: returnMap.customerCount,
    				totalPages: totalPages,

					visiblePageLinks: 5,

					showGoToPage: true,
  					showRowsPerPage: true,
  					showRowsInfo: true,

					onChangePage: function(index, pageObj) { // returns page_num and rows_per_page after a link has clicked
						queryCustomerByConditionsForPage(pageObj.currentPage, pageObj.rowsPerPage)
  					}
  				});
				//显示列表活动前，设置全选框处于未选中状态
				$("#checkAll").prop("checked", false);
				//显示活动列表
				var htmlStr = "";
				$.each(returnMap.customerList, function (index, customer){
					htmlStr+="<tr>";
					htmlStr+="<td><input type=\"checkbox\" value='"+customer.id+"' /></td>";
					htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='detail.jsp';\">"+customer.name+"</a></td>";
					htmlStr+="<td>"+customer.owner+"</td>";
					htmlStr+="<td>"+customer.phone+"</td>";
					htmlStr+="<td>"+customer.website+"</td>";
					htmlStr+="</tr>";
				});
				$("#tBody").html(htmlStr);
			}
		});
	}

	function formJudge(owner, name, website, phone){
		if(owner ==""){
			alert("‘所有者’不能为空！");
			return "false";
		};
		if(name ==""){
			alert("‘名称’不能为空！");
			return "false";
		};
		var websiteJudge = /(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?/;
		if(!websiteJudge.test(website)){
			alert("网址格式错误！");
			return "false";
		};
		var phoneJudge = /\d{3}-\d{8}|\d{4}-\d{7}/;
		if(!phoneJudge.test(phone)){
			alert("座机号码格式错误！");
			return "false";
		};
	}

</script>
</head>
<body>

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createCustomerForm">

						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-customerOwner">
								  <option></option>
								  <c:forEach items="${userList}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName">
							</div>
						</div>

						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="date" class="form-control" id="create-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateCustomerBtn">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="edit-customerId">

						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerOwner">
								  <option></option>
								  <c:forEach items="${userList}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" value="动力节点">
							</div>
						</div>

						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="date" class="form-control" id="edit-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveEditCustomer">更新</button>
				</div>
			</div>
		</div>
	</div>




	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
			</div>
		</div>
	</div>

	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="query-phone">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input class="form-control" type="text" id="query-website">
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="queryCustomerBtn">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createCustomerBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editCustomerBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>

			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll" /></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="tBody">
					</tbody>
				</table>
				<div id="pagination"></div>
			</div>

<%--			<div style="height: 50px; position: relative;top: 30px;">--%>
<%--				<div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
<%--				</div>--%>
<%--				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
<%--					<div class="btn-group">--%>
<%--						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
<%--							10--%>
<%--							<span class="caret"></span>--%>
<%--						</button>--%>
<%--						<ul class="dropdown-menu" role="menu">--%>
<%--							<li><a href="#">20</a></li>--%>
<%--							<li><a href="#">30</a></li>--%>
<%--						</ul>--%>
<%--					</div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
<%--				</div>--%>
<%--				<div style="position: relative;top: -88px; left: 285px;">--%>
<%--					<nav>--%>
<%--						<ul class="pagination">--%>
<%--							<li class="disabled"><a href="#">首页</a></li>--%>
<%--							<li class="disabled"><a href="#">上一页</a></li>--%>
<%--							<li class="active"><a href="#">1</a></li>--%>
<%--							<li><a href="#">2</a></li>--%>
<%--							<li><a href="#">3</a></li>--%>
<%--							<li><a href="#">4</a></li>--%>
<%--							<li><a href="#">5</a></li>--%>
<%--							<li><a href="#">下一页</a></li>--%>
<%--							<li class="disabled"><a href="#">末页</a></li>--%>
<%--						</ul>--%>
<%--					</nav>--%>
<%--				</div>--%>
<%--			</div>--%>

		</div>

	</div>
</body>
</html>
