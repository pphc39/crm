<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.io.*, java.util.*, javax.servlet.*"%>
<html>
<head>
<meta charset="UTF-8">

<link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<!--分页插件-->
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">

	$(function(){
		queryClueByConditionsForPage(1, 10);


		$("#queryClueBtn").click(function (){
			queryClueByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});
		$("#query-fullname").keyup(function (){
			queryClueByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});
		$("#query-company").keyup(function (){
			queryClueByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});
		$("#query-phone").keyup(function (){
			queryClueByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});
		$("#query-source").change(function (){
			queryClueByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});
		$("#query-owner").keyup(function (){
			queryClueByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});
		$("#query-mphone").keyup(function (){
			queryClueByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});
		$("#query-state").change(function (){
			queryClueByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});

		$("#createClueBtn").click(function (){
			$("#createClueModal").modal("show");
			$("#createClueForm").get(0).reset();
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

		$("#saveCreateClueBtn").click(function (){
			var owner = $("#create-clueOwner").val();
			var company = $("#create-company").val();
			var appellation = $("#create-appellation").val();
			var fullname = $("#create-fullname").val();
			var job = $("#create-job").val();
			var email = $("#create-email").val();
			var phone = $("#create-phone").val();
			var website = $("#create-website").val();
			var mphone = $("#create-mphone").val();
			var state = $("#create-state").val();
			var source = $("#create-source").val();
			var description = $("#create-description").val();
			var contactSummary = $("#create-contactSummary").val();
			var nextContactTime = $("#create-nextContactTime").val();
			var address = $("#create-address").val();
			if(formJudge(owner, company, appellation, fullname, email, phone, website, mphone, state, source) == "false"){
				return;
			}
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/clue/saveCreateClue',
				data:{owner:owner, company:company, appellation:appellation, fullname:fullname, job:job, email:email, phone:phone, website:website, mphone:mphone, state:state,
				source:source, description:description, contactSummary:contactSummary, nextContactTime:nextContactTime, address:address},
				type:'post',
				dataType:'json',
				success:function (returnObj){
					if(returnObj.flag=="1"){
						$("#createClueModal").modal("hide");
						queryClueByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'))
					}else {
						alert(returnObj.message);
						$("#createClueModal").modal("show");
					}
				}
			});
		});

		$("#editClueBtn").click(function (){
			var checkedObj = $("#tBody input[type='checkbox']:checked");
			if(checkedObj.size()==0){
				alert("请选择要修改的线索！");
				return;
			};
			if(checkedObj.size()>1){
				alert("一次只能修改一条线索！");
				return;
			};
			var id = checkedObj.val();
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/clue/queryClueById',
				data:{id:id},
				type:'post',
				dataType:'json',
				success:function (clue){
					$("#edit-clueId").val(clue.id);
					$("#edit-clueOwner").val(clue.owner);
					$("#edit-company").val(clue.company);
					$("#edit-appellation").val(clue.appellation);
					$("#edit-fullname").val(clue.fullname);
					$("#edit-job").val(clue.job);
					$("#edit-email").val(clue.email);
					$("#edit-phone").val(clue.phone);
					$("#edit-website").val(clue.website);
					$("#edit-mphone").val(clue.mphone);
					$("#edit-state").val(clue.state);
					$("#edit-source").val(clue.source);
					$("#edit-description").val(clue.description);
					$("#edit-contactSummary").val(clue.contactSummary);
					$("#edit-nextContactTime").val(clue.nextContactTime);
					$("#edit-address").val(clue.address);
					$("#editClueModal").modal("show");
				}
			});
		});

		$("#saveEditClueBtn").click(function (){
			var id = $("#edit-clueId").val();
			var owner = $("#edit-clueOwner").val();
			var company = $("#edit-company").val();
			var appellation = $("#edit-appellation").val();
			var fullname = $("#edit-fullname").val();
			var job = $("#edit-job").val();
			var email = $("#edit-email").val();
			var phone = $("#edit-phone").val();
			var website = $("#edit-website").val();
			var mphone = $("#edit-mphone").val();
			var state = $("#edit-state").val();
			var source = $("#edit-source").val();
			var description = $("#edit-description").val();
			var contactSummary = $("#edit-contactSummary").val();
			var nextContactTime = $("#edit-nextContactTime").val();
			var address = $("#edit-address").val();
			if(formJudge(owner, company, appellation, fullname, email, phone, website, mphone, state, source) == "false"){
				return;
			}
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/clue/saveEditClue',
				data:{id:id, owner:owner, company:company, appellation:appellation, fullname:fullname, job:job, email:email, phone:phone, website:website, mphone:mphone, state:state,
				source:source, description:description, contactSummary:contactSummary, nextContactTime:nextContactTime, address:address},
				type:'post',
				dataType:'json',
				success:function (returnObj){
					if(returnObj.flag=="1"){
						$("#editClueModal").modal("hide");
						queryClueByConditionsForPage($("#pagination").bs_pagination('getOption', 'currentPage'), $("#pagination").bs_pagination('getOption', 'rowsPerPage'))
					}else {
						alert(returnObj.message);
						$("#editClueModal").modal("show");
					}
				}
			});
		});

        $("#deleteClueBtn").click(function (){
			var checkedObj = $("#tBody input[type='checkbox']:checked");
			if(checkedObj.size()==0){
				alert("请至少选择一条线索删除！");
				return;
			}
			var ids = "";
			$.each(checkedObj, function (){
				ids+= "id=" + this.value + "&";
			});
			ids = ids.substr(0, ids.length-1);
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/clue/deleteClueByIds',
				data:ids,
				type:'post',
				dataType:'json',
				success:function (returnObj){
					if(returnObj.flag=="1"){
						queryClueByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
					}else {
						alert(returnObj.message);
					}
				}
			});
		});
	});

	function queryClueByConditionsForPage(pageNo, pageSize){
		var fullname = $("#query-fullname").val();
		var company = $("#query-company").val();
		var phone = $("#query-phone").val();
		var source = $("#query-source").val()
		var owner = $("#query-owner").val();
		var mphone = $("#query-mphone").val();;
		var state = $("#query-state").val();

		$.ajax({
			url:'${pageContext.request.contextPath}/workbench/clue/queryClueByConditionsForPage',
			data:{fullname:fullname, company:company, phone:phone, source:source, owner:owner, mphone:mphone, state:state, pageNo:pageNo, pageSize:pageSize},
			type:'post',
			dataType:'json',
			success:function (returnMap){
				//计算总页数
				var totalPages = 0;
				if (returnMap.clueCount % pageSize == 0){
					totalPages = returnMap.clueCount/pageSize;
				}else {
					totalPages = parseInt(returnMap.clueCount/pageSize) + 1;
				}
				$("#pagination").bs_pagination({
					currentPage: pageNo,

					rowsPerPage: pageSize,
					totalRows: returnMap.clueCount,
    				totalPages: totalPages,

					visiblePageLinks: 5,

					showGoToPage: true,
  					showRowsPerPage: true,
  					showRowsInfo: true,

					onChangePage: function(index, pageObj) { // returns page_num and rows_per_page after a link has clicked
						queryClueByConditionsForPage(pageObj.currentPage, pageObj.rowsPerPage)
  					}
  				});
				$("#checkAll").prop("checked", false);
				var htmlStr = "";
				$.each(returnMap.clueList, function (index, clue){
					htmlStr+="<tr class=\"active\">";
					htmlStr+="		<td><input type=\"checkbox\" value=\""+clue.id+"\" /></td>";
					htmlStr+="		<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='${pageContext.request.contextPath}/workbench/clue/toClueDetail?id="+clue.id+"';\">"+clue.fullname+clue.appellation+"</a></td>";
					htmlStr+="		<td>"+clue.company+"</td>";
					htmlStr+="		<td>"+clue.phone+"</td>";
					htmlStr+="		<td>"+clue.mphone+"</td>";
					htmlStr+="		<td>"+clue.source+"</td>";
					htmlStr+="		<td>"+clue.owner+"</td>";
					htmlStr+="		<td>"+clue.state+"</td>";
					htmlStr+="	</tr>";
				});
				$("#tBody").html(htmlStr);
			}
		});
	}

	function formJudge(owner, company, appellation, fullname, email, phone, website, mphone, state, source){
		if(owner==""){
				alert("所有者不能为空！");
				return "false";
			};
			if(company==""){
				alert("公司不能为空！");
				return "false";
			};
			if(appellation==""){
				alert("称呼不能为空！");
				return "false";
			};
			if(fullname==""){
				alert("姓名不能为空！");
				return "false";
			};
			var emailJudge = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
			if(!emailJudge.test(email)){
				alert("邮箱格式错误！");
				return "false";
			};
			var phoneJudge = /\d{3}-\d{8}|\d{4}-\d{7}/;
			if(!phoneJudge.test(phone)){
				alert("座机号码格式错误！");
				return "false";
			};
			var websiteJudge = /(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?/;
			if(!websiteJudge.test(website)){
				alert("网址格式错误！");
				return "false";
			};
			var mphoneJudge = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
			if(!mphoneJudge.test(mphone)){
				alert("手机号码格式错误！");
				return "false";
			};
			if(state==""){
				alert("线索状态不能为空！");
				return "false";
			};
			if(source==""){
				alert("线索来源不能为空！");
				return "false";
			};
	}

</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form id="createClueForm" class="form-horizontal" role="form">

						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>

						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
									<option></option>
									<c:forEach items="${appellationList}" var="appellation">
										<option value="${appellation.id}">${appellation.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>

						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>

						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>

						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
									<option></option>
									<c:forEach items="${clueStateList}" var="clueState">
										<option value="${clueState.id}">${clueState.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
									<option></option>
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>


						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
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
					<button type="button" class="btn btn-primary" id="saveCreateClueBtn">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="edit-clueId">

						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
									<option></option>
									<c:forEach items="${appellationList}" var="appellation">
										<option value="${appellation.id}">${appellation.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" value="李四">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
									<option></option>
									<c:forEach items="${clueStateList}" var="clueState">
										<option value="${clueState.id}">${clueState.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
									<option></option>
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="date" class="form-control" id="edit-nextContactTime" value="2017-05-01">
								</div>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveEditClueBtn">更新</button>
				</div>
			</div>
		</div>
	</div>




	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
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
				      <input id="query-fullname" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input id="query-company" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input id="query-phone" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select id="query-source" class="form-control">
						  <option></option>
						  <c:forEach items="${sourceList}" var="source">
							  <option value="${source.id}">${source.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <br>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="query-owner" class="form-control" type="text">
				    </div>
				  </div>



				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input id="query-mphone" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select id="query-state" class="form-control">
						  <option></option>
						  <c:forEach items="${clueStateList}" var="clueState">
							  <option value="${clueState.id}">${clueState.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="queryClueBtn">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createClueBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editClueBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteClueBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>


			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="tBody">
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>--%>
<%--							<td>动力节点</td>--%>
<%--							<td>010-84846003</td>--%>
<%--							<td>12345678901</td>--%>
<%--							<td>广告</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>已联系</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>--%>
<%--                            <td>动力节点</td>--%>
<%--                            <td>010-84846003</td>--%>
<%--                            <td>12345678901</td>--%>
<%--                            <td>广告</td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>已联系</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
				<div id="pagination"></div>
			</div>

<%--			<div style="height: 50px; position: relative;top: 60px;">--%>
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
