<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">

<link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
<script type="text/javascript">

	$(function (){
		fillingForm();

		$("#edit-customerName").typeahead({
			source:function (jquery, process){
				$.ajax({
					url:'${pageContext.request.contextPath}/workbench/transaction/queryCustomerNameByName',
					data:{name:jquery},
					type:'post',
					dataType:'json',
					success:function (nameList){
						process(nameList);
					}
				});
			}
		});

		$("#edit-customerName").change(function (){
			$("#edit-contactsName").val("");
			$("#edit-contactsId").val("");
		});

		$("#edit-transactionStage").change(function (){
			var stageValue = $("#edit-transactionStage option:selected").text();
			if (stageValue==""){
				$("#edit-possibility").val("");
				return;
			}
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/transaction/queryPossibilityByStage',
				data:{stageValue:stageValue},
				type:'post',
				dataType:'json',
				success:function (possibility){
					$("#edit-possibility").val(possibility);
				}
			});
		});

		$("#edit-activity").click(function (){
			$("#activityName").val("");
			$("#tBody-activity").html("");
			$("#findMarketActivity").modal("show");
		});

		$("#activityName").keyup(function (){
			var name = this.value;
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/transaction/queryActivityByName',
				data:{name:name},
				type:'post',
				dataType:'json',
				success:function (activityList){
					var htmlStr = "";
					$.each(activityList, function (index, activity){
						htmlStr+="<tr>";
						htmlStr+="<td><input type=\"radio\" value='"+activity.name+"' activityId='"+activity.id+"' name=\"activity\"/></td>";
						htmlStr+="<td>"+activity.name+"</td>";
						htmlStr+="<td>"+activity.startDate+"</td>";
						htmlStr+="<td>"+activity.endDate+"</td>";
						htmlStr+="<td>"+activity.owner+"</td>";
						htmlStr+="</tr>";
					});
					$("#tBody-activity").html(htmlStr);
				}
			});
		});

		$("#tBody-activity").on("click", "input[type='radio']", function (){
			var activityName = this.value;
			var activityId = $(this).attr("activityId");
			$("#edit-activityName").val(activityName);
			$("#edit-activityId").val(activityId);
			$("#findMarketActivity").modal("hide");
		});

		$("#edit-contacts").click(function (){
			var customerName = $("#edit-customerName").val();
			if (customerName==""){
				alert("请选输入客户名称！");
				return;
			}
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/transaction/queryCustomerIdByName',
				data:{name:customerName},
				type:'post',
				dataType:'json',
				success:function (returnObj){
					if(returnObj.flag=="1"){
						$("#customerId").val(returnObj.returnData.id);
					}else {
						$("#customerId").val("");
					}
					$("#contactsName").val("");
					$("#tBody-contacts").html("");
					$("#findContacts").modal("show");
				}
			});
		});

		$("#contactsName").keyup(function (){
			var fullname = this.value;
			var customerId = $("#customerId").val();
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/transaction/queryContactsByNameAndCustomerId',
				data:{fullname:fullname, customerId:customerId},
				type:'post',
				dataType:'json',
				success:function (contactsList){
					var htmlStr = "";
					$.each(contactsList, function (index, contacts){
						htmlStr+="<tr>";
						htmlStr+="<td><input type=\"radio\" value='"+contacts.fullname+"' contactsId='"+contacts.id+"' name=\"activity\"/></td>";
						htmlStr+="<td>"+contacts.fullname+"</td>";
						htmlStr+="<td>"+contacts.email+"</td>";
						htmlStr+="<td>"+contacts.mphone+"</td>";
						htmlStr+="</tr>";
					})
					$("#tBody-contacts").html(htmlStr);
				}
			});
		});

		$("#tBody-contacts").on("click", "input[type='radio']", function (){
			var contactsName = this.value;
			var contactsId = $(this).attr("contactsId");
			$("#edit-contactsName").val(contactsName);
			$("#edit-contactsId").val(contactsId);
			$("#findContacts").modal("hide");
		});

		$("#saveEditTransactionBtn").click(function (){
			var id = $("#edit-transactionId").val();
			var owner = $("#edit-transactionOwner").val();
			var money = $("#edit-amountOfMoney").val();
			var name = $("#edit-transactionName").val();
			var expectedDate = $("#edit-expectedClosingDate").val();
			var customerName = $("#edit-customerName").val();
			var stage = $("#edit-transactionStage").val();
			var type = $("#edit-transactionType").val();
			var source = $("#edit-clueSource").val();
			var activityId = $("#edit-activityId").val();
			var contactsId = $("#edit-contactsId").val();
			var description = $("#edit-description").val();
			var contactSummary = $("#edit-contactSummary").val();
			var nextContactTime = $("#edit-nextContactTime").val();
			alert(activityId+"****"+contactsId);
			//表单验证
			if(owner==""){
				alert("所有者不能为空！");
				return;
			}
			var moneyJudge = /^(([1-9]\d*)|0)$/;
			if(!moneyJudge.test(money)){
				alert("‘金额’只能为非负整数！");
				return;
			}
			if(name==""){
				alert("‘名称’不能为空！");
				return;
			}
			if(expectedDate==""){
				alert("‘预计成交日期’不能为空！");
				return;
			}
			if(customerName==""){
				alert("‘客户名称’不能为空！");
				return;
			}
			if(stage==""){
				alert("‘阶段’不能为空！");
				return;
			}
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/transaction/saveEditTransaction',
				data:{id:id, owner:owner, money:money, name:name, expectedDate:expectedDate, customerName:customerName,
					stage:stage, type:type, source:source, activityId:activityId, contactsId:contactsId, description:description, contactSummary:contactSummary, nextContactTime:nextContactTime},
				type:'post',
				dataType:'json',
				success:function (returnObj){
					if(returnObj.flag=="1"){
						window.location.href = "${pageContext.request.contextPath}/workbench/transaction/index";
					}else {
						alert(returnObj.message);
					}
				}
			});
		});
	});

	function fillingForm(){
		var id = $("#edit-transactionId").val();
		$.ajax({
			url:'${pageContext.request.contextPath}/workbench/transaction/queryTransactionForEditById',
			data:{id:id},
			type:'post',
			dataType:'json',
			success:function (returnMap){
				$("#edit-transactionOwner").val(returnMap.transaction.owner);
				$("#edit-amountOfMoney").val(returnMap.transaction.money);
				$("#edit-transactionName").val(returnMap.transaction.name);
				$("#edit-expectedClosingDate").val(returnMap.transaction.expectedDate);
				$("#edit-customerName").val(returnMap.customer.name);
				$("#edit-transactionStage").val(returnMap.transaction.stage);
				$("#edit-transactionType").val(returnMap.transaction.type);
				$("#edit-possibility").val(returnMap.transaction.possibility);
				$("#edit-clueSource").val(returnMap.transaction.source);
				$("#edit-activityId").val(returnMap.transaction.activityId);
				$("#edit-activityName").val(returnMap.activity.name);
				$("#edit-contactsId").val(returnMap.transaction.contactsId);
				$("#edit-contactsName").val(returnMap.contacts.fullname);
				$("#edit-description").val(returnMap.transaction.description);
				$("#edit-contactSummary").val(returnMap.transaction.contactSummary);
				$("#edit-nextContactTime").val(returnMap.transaction.nextContactTime)
			}
		});
	};

</script>
</head>
<body>

	<!-- 查找市场活动 -->
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" id="activityName" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="tBody-activity">
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
							  <input type="hidden" id="customerId">
						    <input type="text" class="form-control" id="contactsName" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="tBody-contacts">
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>


	<div style="position:  relative; left: 30px;">
		<h3>修改交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveEditTransactionBtn">保存</button>
			<button type="button" class="btn btn-default" onclick="javascript:history.go(-1);">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<input type="hidden" id="edit-transactionId" value="${transaction.id}">
		<div class="form-group">
			<label for="edit-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-transactionOwner">
					<option></option>
					<c:forEach items="${userList}" var="user">
						<option value="${user.id}">${user.name}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-amountOfMoney">
			</div>
		</div>

		<div class="form-group">
			<label for="edit-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-transactionName" >
			</div>
			<label for="edit-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="date" class="form-control" id="edit-expectedClosingDate">
			</div>
		</div>

		<div class="form-group">
			<label edit="create-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="edit-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="edit-transactionStage">
			  	<option></option>
					<c:forEach items="${stageList}" var="stage">
						<option value="${stage.id}">${stage.value}</option>
					</c:forEach>
			  </select>
			</div>
		</div>

		<div class="form-group">
			<label for="edit-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-transactionType">
				  <option></option>
					<c:forEach items="${transactionTypeList}" var="transactionType">
						<option value="${transactionType.id}">${transactionType.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-possibility" readonly>
			</div>
		</div>

		<div class="form-group">
			<label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-clueSource">
				  <option></option>
					<c:forEach items="${sourceList}" var="source">
						<option value="${source.id}">${source.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="edit-activity"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="edit-activityId">
				<input type="text" class="form-control" id="edit-activityName" readonly>
			</div>
		</div>

		<div class="form-group">
			<label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="edit-contacts"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="edit-contactsId">
				<input type="text" class="form-control" id="edit-contactsName" readonly>
			</div>
		</div>

		<div class="form-group">
			<label for="edit-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-description" ></textarea>
			</div>
		</div>

		<div class="form-group">
			<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-contactSummary" ></textarea>
			</div>
		</div>

		<div class="form-group">
			<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="date" class="form-control" id="edit-nextContactTime">
			</div>
		</div>

	</form>
</body>
</html>
