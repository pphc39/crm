<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
<meta charset="UTF-8">

<link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;

	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});

		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});

		$("#clueRemarkListDiv").on("mouseover", ".remarkDiv", function (){
			$(this).children("div").children("div").show();
		});

		$("#clueRemarkListDiv").on("mouseout", ".remarkDiv", function (){
			$(this).children("div").children("div").hide();
		});

		// $(".remarkDiv").mouseover(function(){
		// 	$(this).children("div").children("div").show();
		// });
		//
		// $(".remarkDiv").mouseout(function(){
		// 	$(this).children("div").children("div").hide();
		// });

		// $(".myHref").mouseover(function(){
		// 	$(this).children("span").css("color","red");
		// });
		//
		// $(".myHref").mouseout(function(){
		// 	$(this).children("span").css("color","#E6E6E6");
		// });

		$("#clueRemarkListDiv").on("mouseover", ".myHref", function (){
			$(this).children("span").css("color","red");
		});

		$("#clueRemarkListDiv").on("mouseout", ".myHref", function (){
			$(this).children("span").css("color","#E6E6E6");
		});

		$("#saveCreateClueRemarkBtn").click(function (){
			var noteContent = $.trim($("#remark").val());
			var clueId = '${clue.id}';
			if(noteContent==""){
				alert("请输入备注内容！");
				return;
			}
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/clue/saveCreateClueRemark',
				data:{noteContent:noteContent, clueId:clueId},
				type:'post',
				dataType:'json',
				success:function (returnObj){
					if(returnObj.flag=='1'){
						$("#remark").val("");
						var htmlStr = "";
						htmlStr+="<div class=\"remarkDiv\" id=\"div_"+returnObj.returnData.id+"\" style=\"height: 60px;\">";
						htmlStr+="<img title=\"${sessionScope.sessionUser.name}\" src=\"${pageContext.request.contextPath}/image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
						htmlStr+="<div style=\"position: relative; top: -40px; left: 40px;\" >";
						htmlStr+="<h5>"+returnObj.returnData.noteContent+"</h5>";
						htmlStr+="<font color=\"gray\">线索</font> <font color=\"gray\">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style=\"color: gray;\"> "+returnObj.returnData.createTime+" 由${sessionScope.sessionUser.name}创建</small>";
						htmlStr+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
						htmlStr+="<a class=\"myHref\" clueRemarkId=\""+returnObj.returnData.id+"\" name=\"editA\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						htmlStr+="&nbsp;&nbsp;&nbsp;&nbsp;";
						htmlStr+="<a class=\"myHref\" clueRemarkId=\""+returnObj.returnData.id+"\" name=\"deleteA\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						htmlStr+="</div>";
						htmlStr+="</div>";
						htmlStr+="</div>";
						$("#clueRemark").after(htmlStr);
					}else {
						alert(returnObj.message);
					}
				}
			});
		});

		//删除备注
		$("#clueRemarkListDiv").on("click", "a[name='deleteA']", function (){
			var id = $(this).attr("clueRemarkId");
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/clue/deleteClueRemarkById',
				data:{id:id},
				type:'post',
				dataType:'json',
				success:function (returnObj){
					if(returnObj.flag=='1'){
						$("#div_"+id).remove();
					}else {
						alert(returnObj.message);
					}
				}
			});
		});

		//修改备注
		$("#clueRemarkListDiv").on("click", "a[name='editA']", function (){
			var id = $(this).attr("clueRemarkId");
			var noteContent = $("#div_"+id+" h5").text();

			$("#edit-id").val(id);
			$("#edit-noteContent").text(noteContent);
			$("#editRemarkModal").modal("show");
		});

		$("#updateRemarkBtn").click(function (){
			var id = $("#edit-id").val();
			var noteContent = $.trim($("#edit-noteContent").val());
			if(noteContent==""){
				alert("请输入备注内容！");
				return;
			}
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/clue/saveEditClueRemark',
				data:{id:id, noteContent:noteContent},
				type:'post',
				dataType:'json',
				success:function (returnObj){
					if(returnObj.flag=="1"){
						$("#editRemarkModal").modal("hide");
						$("#div_"+returnObj.returnData.id+" h5").text(returnObj.returnData.noteContent);
						$("#div_"+returnObj.returnData.id+" small").text(" "+returnObj.returnData.editTime+" 由${sessionScope.sessionUser.name}修改");
					}else {
						alert(returnObj.message);
					}
				}
			});
		});

		$("#bundActivityBtn").click(function (){
			$("#searchName").val("");
			$("#tBodySearch").html("");
			$("#bundModal").modal("show");
		});

		//输入市场活动名称，支持模糊查询
		$("#searchName").keyup(function (){
			var name = $("#searchName").val();
			var clueId = '${clue.id}';
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/clue/queryActivityByNameAndClueId',
				data:{name:name, clueId:clueId},
				type:'post',
				dataType:'json',
				success:function (activityList){
					$("#checkAll").prop("checked", false);
					var htmlStr = "";
					$.each(activityList, function (index, activity){
						htmlStr+="<tr>";
						htmlStr+="<td><input value=\""+activity.id+"\" type=\"checkbox\"/></td>";
						htmlStr+="<td>"+activity.name+"</td>";
						htmlStr+="<td>"+activity.startDate+"</td>";
						htmlStr+="<td>"+activity.endDate+"</td>";
						htmlStr+="<td>"+activity.owner+"</td>";
						htmlStr+="</tr>";
					})
					$("#tBodySearch").html(htmlStr);
				}
			});
		});

		$("#checkAll").click(function (){
			$("#tBodySearch input[type='checkbox']").prop("checked", this.checked);
		});

		$("#tBodySearch").on("click", "input[type='checkbox']", function (){
			if($("#tBodySearch input[type='checkbox']").size()==$("#tBodySearch input[type='checkbox']:checked").size()){
				$("#checkAll").prop("checked", true);
			}else {
				$("#checkAll").prop("checked", false);
			}
		});

		$("#saveBundActivityBtn").click(function (){
			var checkedObjs = $("#tBodySearch input[type='checkbox']:checked");
			if(checkedObjs.size()==0){
				alert("请至少关联一项市场活动！");
				return;
			}
			var ids = "";
			$.each(checkedObjs, function (){
				ids+= "activityId=" + this.value + "&";
			});
			ids+= "clueId=${clue.id}";
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/clue/saveBundActivityByList',
				data:ids,
				type:'post',
				dataType:'json',
				success:function (returnObj){
					if(returnObj.flag=="1"){
						$("#bundModal").modal("hide");
						var htmlStr = "";
						$.each(returnObj.returnData, function (index, activity){
							htmlStr+="<tr id='tr_"+activity.id+"'>";
							htmlStr+="<td>"+activity.name+"</td>";
							htmlStr+="<td>"+activity.startDate+"</td>";
							htmlStr+="<td>"+activity.endDate+"</td>";
							htmlStr+="<td>"+activity.owner+"</td>";
							htmlStr+="<td><a activityId=\""+activity.id+"\" href=\"javascript:void(0);\"  style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>";
							htmlStr+="</tr>";
						});
						$("#tBodyShow").append(htmlStr);
					}else {
						alert(returnObj.message);
					}
				}
			});
		});

		$("#tBodyShow").on("click", "a", function (){
			var activityId = $(this).attr("activityId");
			var clueId = '${clue.id}';
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/clue/dropBundActivityByActivityIdAndClueId',
				data:{activityId:activityId, clueId:clueId},
				type:'post',
				dataType:'json',
				success:function (reurnObj){
					if(reurnObj.flag=="1"){
						$("#tr_"+activityId).remove();
					}else {
						alert(reurnObj.message);
					}
				}
			});
		});

		$("#toConvertClueBtn").click(function (){
			var id = '${clue.id}';
			window.location.href = "${pageContext.request.contextPath}/workbench/clue/toConvertClue?id="+id+"";
		});

	});

</script>

</head>
<body>

	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="edit-id">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-noteContent" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>
	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="searchName" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input id="checkAll" type="checkbox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tBodySearch">
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="saveBundActivityBtn">关联</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>

	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${clue.fullname}${clue.appellation} <small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="toConvertClueBtn"><span class="glyphicon glyphicon-retweet"></span> 转换</button>

		</div>
	</div>

	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullname}${clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;"><fmt:formatDate value="${clue.createTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate></small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;"><fmt:formatDate value="${clue.editTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate></small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b><fmt:formatDate value="${clue.nextContactTime}" pattern="yyyy-MM-dd"></fmt:formatDate></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>

	<!-- 备注 -->
	<div id="clueRemarkListDiv" style="position: relative; top: 40px; left: 40px;">
		<div id="clueRemark" class="page-header">
			<h4>备注</h4>
		</div>

		<c:forEach items="${clueRemarkList}" var="clueRemark">
			<div class="remarkDiv" id="div_${clueRemark.id}" style="height: 60px;">
			<img title="${clueRemark.createBy}" src="${pageContext.request.contextPath}/image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>${clueRemark.noteContent}</h5>
				<c:if test="${clueRemark.editFlag=='0'}">
					<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style="color: gray;"> <fmt:formatDate value="${clueRemark.createTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate> 由${clueRemark.createBy}创建</small>
				</c:if>
				<c:if test="${clueRemark.editFlag=='1'}">
					<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style="color: gray;"> <fmt:formatDate value="${clueRemark.editTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate> 由${clueRemark.editBy}修改</small>
				</c:if>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" clueRemarkId="${clueRemark.id}" name="editA" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" clueRemarkId="${clueRemark.id}" name="deleteA" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		</c:forEach>

<%--		<!-- 备注1 -->--%>
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="${pageContext.request.contextPath}/image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>哎呦！</h5>--%>
<%--				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>

<%--		<!-- 备注2 -->--%>
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="${pageContext.request.contextPath}/image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>呵呵！</h5>--%>
<%--				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>

		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveCreateClueRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>

	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="tBodyShow">
						<c:forEach items="${activityList}" var="activity">
							<tr id="tr_${activity.id}">
								<td>${activity.name}</td>
								<td><fmt:formatDate value="${activity.startDate}" pattern="yyyy-MM-dd"></fmt:formatDate></td>
								<td><fmt:formatDate value="${activity.endDate}" pattern="yyyy-MM-dd"></fmt:formatDate></td>
								<td>${activity.owner}</td>
								<td><a activityId="${activity.id}" href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>

			<div>
				<a href="javascript:void(0);" id="bundActivityBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>


	<div style="height: 200px;"></div>
</body>
</html>
