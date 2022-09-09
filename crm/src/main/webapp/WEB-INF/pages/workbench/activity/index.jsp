<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">

<link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<%--<link href="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />--%>

<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<%--<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>--%>
<%--<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>--%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">

	$(function(){

		queryActivityByConditionsForPage(1, 10);

		$("#createActivityBtn").click(function (){
			//清空上一次所创建活动的信息
			$("#createActivityForm").get(0).reset();
			//打开创建活动所需的模态窗口
			$("#createActivityModal").modal("show");
		});

		$("#saveCreateActivityBtn").click(function (){
			var owner = $("#create-marketActivityOwner").val();
			var name = $.trim($("#create-marketActivityName").val());
			var startDate = $("#create-startDate").val();
			var endDate = $("#create-endDate").val();
			var cost = $.trim($("#create-cost").val());
			var description = $.trim($("#create-description").val());
			if(owner==""){
				alert("所有者不能为空！");
				return;
			}
			if(name==""){
				alert("名称不能为空！");
				return;
			}
			if(startDate!="" && endDate!=""){
				if(startDate>endDate){
					alert("结束时间不能早于起始时间！");
					return;
				}
			}
			//判断‘成本’是否满足只能为非负整数
			var costJudge = /^(([1-9]\d*)|0)$/;
			if(!costJudge.test(cost)){
				alert("‘成本’只能为非负整数");
				return;
			}

			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/activity/saveCreateActivity',
				data:{owner:owner, name:name, startDate:startDate, endDate:endDate, cost:cost, description:description},
				type:'post',
				dataType:'json',
				success:function (returnObject){
					if(returnObject.flag=="1"){
						//保存成功。关闭模态窗口
						$("#createActivityModal").modal("hide");
						//实时更新活动列表
						queryActivityByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
					}else{
						alert(returnObject.message);
						$("#createActivityModal").modal("show");
					}
				}
			});
		});

		$("#queryActivityBtn").click(function (){
			queryActivityByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});

		//‘所有者’改变后，实时查询
		$("#query-owner").keyup(function (){
			queryActivityByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});
		//‘名称’改变后，实时查询
		$("#query-name").keyup(function (){
			queryActivityByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});
		//‘开始日期’改变后，实时查询
		$("#query-startDate").change(function (){
			queryActivityByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});
		//‘结束日期’改变后，实时查询
		$("#query-endDate").change(function (){
			queryActivityByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});

		//全选框点击后，下面所有的选择框都要和全选框的状态保持一致
		$("#checkAll").click(function (){
			$("#tBody input[type='checkbox']").prop("checked", this.checked)
		});

		//下面的选择框如果全部选中，则全选框选中，否则全选框处于未选中状态
		//tBody中的checkbox是动态生成的，不能用.click
		$("#tBody").on("click", "input[type='checkbox']", function (){
			if($("#tBody input[type='checkbox']").size()==$("#tBody input[type='checkbox']:checked").size()){
				$("#checkAll").prop("checked", true);
			}else{
				$("#checkAll").prop("checked", false);
			}
		})

		//删除功能实现
		$("#deleteActivityBtn").click(function (){
			var checkedObj = $("#tBody input[type='checkbox']:checked");
			if(checkedObj.size()==0){
				return;
				alert("请选择要删除的活动！")
			};
			if(window.confirm("确定要删除吗？")){
				var ids = "";
				$.each(checkedObj, function (){
					ids+= "id=" + this.value + "&";
				});
				ids = ids.substr(0, ids.length-1);
				$.ajax({
				url:'${pageContext.request.contextPath}/workbench/activity/deleteActivityByIds',
				data:ids,
				type:'post',
				dataType:'json',
				success:function (returnObj){
					if(returnObj.flag=="1"){
						queryActivityByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'))
					}else {
						alert(returnObj.message)
					}
				}
			});
			}
		});

		$("#editActivityBtn").click(function (){
			var checkedIds = $("#tBody input[type='checkbox']:checked");
			if(checkedIds.size()==0){
				alert("请选择要修改的活动！");
				return;
			}
			if(checkedIds.size()>1){
				alert("每次只能修改一个活动！");
				return;
			}
			var id = checkedIds.val();
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/activity/queryActivityById',
				data:{id:id},
				type:'post',
				dataType:'json',
				success:function (activity){
					$("#edit-activityId").val(activity.id);
					$("#edit-marketActivityOwner").val(activity.owner);
					$("#edit-marketActivityName").val(activity.name);
					$("#edit-startDate").val(activity.startDate);
					$("#edit-endDate").val(activity.endDate);
					$("#edit-cost").val(activity.cost);
					$("#edit-description").val(activity.description);
					$("#editActivityModal").modal("show");
				}
			});
		});

		$("#updateEditActivityBtn").click(function (){
			var id = $("#edit-activityId").val()
			var owner = $("#edit-marketActivityOwner").val();
			var name = $.trim($("#edit-marketActivityName").val());
			var startDate = $("#edit-startDate").val();
			var endDate = $("#edit-endDate").val();
			var cost = $.trim($("#edit-cost").val());
			var description = $.trim($("#edit-description").val());
			if(owner==""){
				alert("所有者不能为空！");
				return;
			}
			if(name==""){
				alert("名称不能为空！");
				return;
			}
			if(startDate!="" && endDate!=""){
				if(startDate>endDate){
					alert("结束时间不能早于起始时间！");
					return;
				}
			}
			//判断‘成本’是否满足只能为非负整数
			var costJudge = /^(([1-9]\d*)|0)$/;
			if(!costJudge.test(cost)){
				alert("‘成本’只能为非负整数");
				return;
			}

			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/activity/updateEditActivity',
				data:{id:id, owner:owner, name:name, startDate:startDate, endDate:endDate, cost:cost, description:description},
				type:'post',
				dataType:'json',
				success:function (returnObject){
					if(returnObject.flag=="1"){
						//保存成功。关闭模态窗口
						$("#editActivityModal").modal("hide");
						//刷新活动列表，保持页号和每页条数不变
						queryActivityByConditionsForPage($("#pagination").bs_pagination('getOption', 'currentPage'), $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
					}else{
						alert(returnObject.message);
						$("#editActivityModal").modal("show");
					}
				}
			});
		});

		//批量导出活动列表
		$("#exportAllActivityBtn").click(function (){
			window.location.href = "${pageContext.request.contextPath}/workbench/activity/exportAllActivity";
		});

		//导出查询后的所有活动
		$("#exportAllQueryActivityBtn").click(function (){
			var owner = $("#query-owner").val();
			var name = $("#query-name").val();
			var startDate = $("#query-startDate").val();
			var endDate = $("#query-endDate").val();
			window.location.href = "${pageContext.request.contextPath}/workbench/activity/exportAllQueryActivity?owner="+owner+"&name="+name+"&startDate="+startDate+"&endDate="+endDate+"";
		});

		//选择导出活动列表
		$("#exportSomeActivityBtn").click(function (){
			var checkedObj = $("#tBody input[type='checkbox']:checked")
			if(checkedObj.size()==0){
				alert("请选择要导出的活动！");
				return;
			}
			var ids = ""
			$.each(checkedObj, function (){
				ids+= "id=" + this.value + "&";
			});
			ids = ids.substr(0, ids.length-1);
			window.location.href = "${pageContext.request.contextPath}/workbench/activity/exportSomeActivity?"+ids+"";
		});

		//下载活动模板，用于导入活动文件
		$("#downloadActivityModule").click(function (){
			window.location.href= "${pageContext.request.contextPath}/workbench/activity/downloadActivityModule";
		});

		//导入活动文件
		$("#importActivityBtn").click(function (){
			var activityFileName = $("#activityFile").val();
			var suffix = activityFileName.substr(activityFileName.lastIndexOf(".")+1).toLocaleLowerCase();
			if(suffix != "xls"){
				alert("只能导入格式为xls的文件！");
				return;
			}
			var activityFile = $("#activityFile")[0].files[0];
			var activityFileSize = activityFile.size;
			if(activityFileSize > 5*1024*1024){
				alert("导入的文件大小应该小于5M！");
				return;
			}
			var formData = new FormData();
			formData.append("activityFile", activityFile);
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/activity/importActivityFile',
				data:formData,
				processData:false,
				contentType:false,
				type:'post',
				dataType:'json',
				success:function (returnObj){
					if(returnObj.flag=="1"){
						alert(returnObj.message);
						$("#importActivityModal").modal("hide");
						queryActivityByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
					}else {
						alert(returnObj.message);
						$("#importActivityModal").modal("show");
					}
				}
			});
		});
	});

	function queryActivityByConditionsForPage(pageNo, pageSize){
		var owner = $("#query-owner").val();
		var name = $("#query-name").val();
		var startDate = $("#query-startDate").val();
		var endDate = $("#query-endDate").val();
		// var pageNo = 1;
		// var pageSize = 10;
		$.ajax({
			url:'${pageContext.request.contextPath}/workbench/activity/queryActivityByConditionsForPage',
			data:{owner:owner, name:name, startDate:startDate, endDate:endDate, pageNo:pageNo, pageSize:pageSize},
			type:'post',
			dataType: 'json',
			success:function (returnMap){
				// $("#activityCount").text(returnMap.activityCount)
				//计算总页数
				var totalPages = 0;
				if(returnMap.activityCount % pageSize == 0){
					totalPages = returnMap.activityCount/pageSize;
				}else {
					totalPages = parseInt(returnMap.activityCount/pageSize) + 1;
				}

				$("#pagination").bs_pagination({
					currentPage: pageNo,

					rowsPerPage: pageSize,
					totalRows: returnMap.activityCount,
    				totalPages: totalPages,

					visiblePageLinks: 5,

					showGoToPage: true,
  					showRowsPerPage: true,
  					showRowsInfo: true,

					onChangePage: function(index, pageObj) { // returns page_num and rows_per_page after a link has clicked
						queryActivityByConditionsForPage(pageObj.currentPage, pageObj.rowsPerPage)
  					}
  				});
				//显示列表活动前，设置全选框处于未选中状态
				$("#checkAll").prop("checked", false);
				//显示活动列表
				var htmlStr = "";
				$.each(returnMap.activityList, function (index, activity){
					htmlStr+="<tr class=\"active\">"
					htmlStr+="<td><input type=\"checkbox\" value=\""+activity.id+"\"/></td>"
					htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='${pageContext.request.contextPath}/workbench/activity/toActivityDetail?id="+activity.id+"';\">"+activity.name+"</a></td>"
                    htmlStr+="<td>"+activity.owner+"</td>"
					htmlStr+="<td>"+activity.startDate+"</td>"
					htmlStr+="<td>"+activity.endDate+"</td>"
					htmlStr+="</tr>"
				});
				$("#tBody").html(htmlStr);
			}
		});
	}

</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form" id="createActivityForm">

						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
									<input type="date" class="form-control" id="create-startDate">
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="date" class="form-control" id="create-endDate">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateActivityBtn">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-activityId">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
								  <c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="date" class="form-control" id="edit-startDate" value="2020-10-10">
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="date" class="form-control" id="edit-endDate" value="2020-10-20">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateEditActivityBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
						<h4 style="color: #ff1c1c">请下载模板填写要导入的活动</h4>
						<input type="button" id="downloadActivityModule" value="下载模板">
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>


	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>

					<div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="date" id="query-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="date" id="query-endDate">
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="queryActivityBtn">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editActivityBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportAllActivityBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（导出所有活动）</button>
					<button id="exportAllQueryActivityBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（导出查询后的所有活动）</button>
                    <button id="exportSomeActivityBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（导出选中的活动）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="tBody">
<%--						<tr class="active">--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>2020-10-10</td>--%>
<%--                            <td>2020-10-20</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
				<div id="pagination"></div>
			</div>

<%--			<div style="height: 50px; position: relative;top: 30px;">--%>
<%--				<div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="activityCount">50</b>条记录</button>--%>
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
