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
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">

	$(function(){
		queryTransactionByConditionsForPage(1, 10);

		$("#query-owner").keyup(function (){
			queryTransactionByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});
		$("#query-name").keyup(function (){
			queryTransactionByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});
		$("#query-customerName").keyup(function (){
			queryTransactionByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});
		$("#query-state").change(function (){
			queryTransactionByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});
		$("#query-type").change(function (){
			queryTransactionByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});
		$("#query-source").change(function (){
			queryTransactionByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});
		$("#query-contactsName").keyup(function (){
			queryTransactionByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});
		$("#queryTransactionBtn").click(function (){
			queryTransactionByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
		});

		$("#createTransactionBtn").click(function (){
			window.location.href = "${pageContext.request.contextPath}/workbench/transaction/toSave";
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

	});

	function queryTransactionByConditionsForPage(pageNo, pageSize){
		var owner = $("#query-owner").val();
		var name = $("#query-name").val();
		var customerName = $("#customerName").val();
		var stage = $("#query-stage").val();
		var type = $("#query-type").val();
		var source = $("#query-source").val();
		var contactsName = $("#query-contactsName").val();
		$.ajax({
			url:'${pageContext.request.contextPath}/workbench/transaction/queryTransactionByConditionsForPage',
			data:{owner:owner, name:name, customerName:customerName, stage:stage, type:type, source:source, contactsName:contactsName, pageNo:pageNo, pageSize:pageSize},
			type:'post',
			dataType:'json',
			success:function (returnMap){
				//???????????????
				var totalPages = 0;
				if(returnMap.transactionCount % pageSize == 0){
					totalPages = returnMap.transactionCount/pageSize;
				}else {
					totalPages = parseInt(returnMap.transactionCount/pageSize) + 1;
				}

				$("#pagination").bs_pagination({
					currentPage: pageNo,

					rowsPerPage: pageSize,
					totalRows: returnMap.transactionCount,
    				totalPages: totalPages,

					visiblePageLinks: 5,

					showGoToPage: true,
  					showRowsPerPage: true,
  					showRowsInfo: true,

					onChangePage: function(index, pageObj) { // returns page_num and rows_per_page after a link has clicked
						queryTransactionByConditionsForPage(pageObj.currentPage, pageObj.rowsPerPage)
  					}
  				});
				//????????????????????????????????????????????????????????????
				$("#checkAll").prop("checked", false);
				//??????????????????
				var htmlStr = "";
				$.each(returnMap.transactionList, function (index, transaction){
					htmlStr+="<tr>";
					htmlStr+="<td><input value='"+transaction.id+"' type=\"checkbox\" /></td>";
					htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='${pageContext.request.contextPath}/workbench/transaction/toTransactionDetail?id="+transaction.id+"';\">"+transaction.name+"</a></td>";
					htmlStr+="<td>"+transaction.customerId+"</td>";
					htmlStr+="<td>"+transaction.stage+"</td>";
					htmlStr+="<td>"+transaction.type+"</td>";
					htmlStr+="<td>"+transaction.owner+"</td>";
					htmlStr+="<td>"+transaction.source+"</td>";
					htmlStr+="<td>"+transaction.contactsId+"</td>";
					htmlStr+="</tr>";
				})
				$("#tBody").html(htmlStr);
			}
		});

		$("#deleteTransactionBtn").click(function (){
			var checkedObjs = $("#tBody input[type='checkbox']:checked");
			if(checkedObjs.size()==0){
				alert("??????????????????????????????????????????");
				return;
			}
			if(window.confirm("?????????????????????")){
				var ids = "";
				$.each(checkedObjs, function (){
					ids+= "id=" + this.value + "&";
				})
				ids = ids.substr(0, ids.length-1);
				$.ajax({
					url:'${pageContext.request.contextPath}/workbench/transaction/deleteTransactionByIds',
					data:ids,
					type:'post',
					dataType:'json',
					success:function (returnObj){
						if(returnObj.flag=="1"){
							queryTransactionByConditionsForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
						}else {
							alert(returnObj.message);
						}
					}
				});
			}
		});

		$("#editTransactionBtn").click(function (){
			var checkedObjs = $("#tBody input[type='checkbox']:checked");
			if(checkedObjs.size()==0){
				alert("??????????????????????????????");
				return;
			}
			if(checkedObjs.size()>1){
				alert("?????????????????????????????????");
				return;
			}
			var id = checkedObjs.val();
			window.location.href = "${pageContext.request.contextPath}/workbench/transaction/toTransactionEdit?id="+id+"";
		});
	};
</script>
</head>
<body>



	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>????????????</h3>
			</div>
		</div>
	</div>

	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">?????????</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">??????</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">????????????</div>
				      <input class="form-control" type="text" id="query-customerName">
				    </div>
				  </div>

				  <br>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">??????</div>
					  <select class="form-control" id="query-stage">
					  	<option></option>
						  <c:forEach items="${stageList}" var="stage">
							  <option value="${stage.id}">${stage.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">??????</div>
					  <select class="form-control" id="query-type">
					  	<option></option>
					  	<c:forEach items="${transactionTypeList}" var="transactionType">
							<option value="${transactionType.id}">${transactionType.value}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">??????</div>
				      <select class="form-control" id="query-source">
						  <option></option>
						  <c:forEach items="${sourceList}" var="source">
							  <option value="${source.id}">${source.value}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">???????????????</div>
				      <input class="form-control" type="text" id="query-contactsName">
				    </div>
				  </div>

				  <button type="submit" class="btn btn-default" id="queryTransactionBtn">??????</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createTransactionBtn"><span class="glyphicon glyphicon-plus"></span> ??????</button>
				  <button type="button" class="btn btn-default" id="editTransactionBtn"><span class="glyphicon glyphicon-pencil"></span> ??????</button>
				  <button type="button" class="btn btn-danger" id="deleteTransactionBtn"><span class="glyphicon glyphicon-minus"></span> ??????</button>
				</div>


			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="checkAll" type="checkbox" /></td>
							<td>??????</td>
							<td>????????????</td>
							<td>??????</td>
							<td>??????</td>
							<td>?????????</td>
							<td>??????</td>
							<td>???????????????</td>
						</tr>
					</thead>
					<tbody id="tBody">
					</tbody>
				</table>
				<div id="pagination"></div>
			</div>

<%--			<div style="height: 50px; position: relative;top: 20px;">--%>
<%--				<div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">???<b>50</b>?????????</button>--%>
<%--				</div>--%>
<%--				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">??????</button>--%>
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
<%--					<button type="button" class="btn btn-default" style="cursor: default;">???/???</button>--%>
<%--				</div>--%>
<%--				<div style="position: relative;top: -88px; left: 285px;">--%>
<%--					<nav>--%>
<%--						<ul class="pagination">--%>
<%--							<li class="disabled"><a href="#">??????</a></li>--%>
<%--							<li class="disabled"><a href="#">?????????</a></li>--%>
<%--							<li class="active"><a href="#">1</a></li>--%>
<%--							<li><a href="#">2</a></li>--%>
<%--							<li><a href="#">3</a></li>--%>
<%--							<li><a href="#">4</a></li>--%>
<%--							<li><a href="#">5</a></li>--%>
<%--							<li><a href="#">?????????</a></li>--%>
<%--							<li class="disabled"><a href="#">??????</a></li>--%>
<%--						</ul>--%>
<%--					</nav>--%>
<%--				</div>--%>
<%--			</div>--%>

		</div>

	</div>
</body>
</html>
