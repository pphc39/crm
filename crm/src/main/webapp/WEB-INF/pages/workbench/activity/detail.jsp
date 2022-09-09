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

		// $(".remarkDiv").mouseover(function(){
		// 	$(this).children("div").children("div").show();
		// });
		$("#activityRemarkListDiv").on("mouseover", ".remarkDiv", function (){
			$(this).children("div").children("div").show();
		});

		// $(".remarkDiv").mouseout(function(){
		// 	$(this).children("div").children("div").hide();
		// });
		$("#activityRemarkListDiv").on("mouseout", ".remarkDiv", function (){
			$(this).children("div").children("div").hide();
		});

		// $(".myHref").mouseover(function(){
		// 	$(this).children("span").css("color","red");
		// });
		//
		// $(".myHref").mouseout(function(){
		// 	$(this).children("span").css("color","#E6E6E6");
		// });

		$("#activityRemarkListDiv").on("mouseover", ".myHref", function (){
			$(this).children("span").css("color","red");
		});

		$("#activityRemarkListDiv").on("mouseout", ".myHref", function (){
			$(this).children("span").css("color","#E6E6E6");
		});

		$("#saveCreateActivityRemark").click(function (){
			var noteContent = $.trim($("#remark").val());
			var activityId = '${activity.id}';
			if(noteContent==""){
				alert("请输入备注内容！");
				return;
			};
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/activity/saveCreateActivityRemark',
				data:{noteContent:noteContent, activityId:activityId},
				type:'post',
				dataType:'json',
				success:function (returnObj){
					if(returnObj.flag=="1"){
						$("#remark").val("");
						var htmlStr = "";
						htmlStr+="<div id=\"div_"+returnObj.returnData.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">";
						htmlStr+="<img title=\"${sessionScope.sessionUser.name}\" src=\"${pageContext.request.contextPath}/image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
						htmlStr+="<div style=\"position: relative; top: -40px; left: 40px;\" >";
						htmlStr+="<h5>"+returnObj.returnData.noteContent+"</h5>";
						htmlStr+="<font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> <b>${activity.name}</b> <small style=\"color: gray;\"> "+returnObj.returnData.createTime+" 由${sessionScope.sessionUser.name}创建</small>";
						htmlStr+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
						htmlStr+="<a class=\"myHref\" name=\"editA\" activityRemarkId=\""+returnObj.returnData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						htmlStr+="&nbsp;&nbsp;&nbsp;&nbsp;";
						htmlStr+="<a class=\"myHref\" name=\"deleteA\" activityRemarkId=\""+returnObj.returnData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						htmlStr+="</div>";
						htmlStr+="</div>";
						htmlStr+="</div>";

						$("#activityRemark").after(htmlStr);
					}else {
						alert(returnObj.message);
					}
				}
			});
		});

		$("#activityRemarkListDiv").on("click", "a[name='deleteA']", function (){
			var id = $(this).attr("activityRemarkId");
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/activity/deleteActivityRemarkById',
				data:{id:id},
				type:'post',
				dataType:'json',
				success:function (returnObj){
					if(returnObj.flag=="1"){
						$("#div_"+id).remove();
					}else {
						alert(returnObj.message);
					}
				}
			});
		});

		$("#activityRemarkListDiv").on("click", "a[name='editA']", function (){
			var id = $(this).attr("activityRemarkId");
			var noteContent = $("#div_"+id+" h5").text();

			$("#edit-id").val(id);
			$("#edit-noteContent").text(noteContent);
			$("#editRemarkModal").modal("show");
		});

		$("#updateRemarkBtn").click(function (){
			var id = $("#edit-id").val();
			var noteContent = $.trim($("#edit-noteContent").val());
			if(noteContent == ""){
				alert("请输入备注内容！");
				return;
			}
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/activity/saveEditActivityRemark',
				data:{id:id, noteContent:noteContent},
				type:'post',
				dataType:'json',
				success:function (returnObj){
					if(returnObj.flag=="1"){
						$("#editRemarkModal").modal("hide");
						$("#div_"+id+" h5").text(returnObj.returnData.noteContent)
						$("#div_"+id+" small").text(" "+returnObj.returnData.editTime+" 由${sessionScope.sessionUser.name}修改")
					}else {
						alert(returnObj.message)
					}
				}
			});
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



	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>

	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-${activity.name} <small><fmt:formatDate value="${activity.startDate}" pattern="yyyy-MM-dd"></fmt:formatDate> ~ <fmt:formatDate value="${activity.endDate}" pattern="yyyy-MM-dd"></fmt:formatDate></small></h3>
		</div>

	</div>

	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b><fmt:formatDate value="${activity.startDate}" pattern="yyyy-MM-dd"></fmt:formatDate></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b><fmt:formatDate value="${activity.endDate}" pattern="yyyy-MM-dd"></fmt:formatDate></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;"><fmt:formatDate value="${activity.createTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate></small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;"><fmt:formatDate value="${activity.editTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate></small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>

	<!-- 备注 -->
	<div id="activityRemarkListDiv" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header" id="activityRemark">
			<h4>备注</h4>
		</div>

		<c:forEach items="${activityRemarkList}" var="activityRemark">
			<div id="div_${activityRemark.id}" class="remarkDiv" style="height: 60px;">
			<img title="${activityRemark.createBy}" src="${pageContext.request.contextPath}/image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>${activityRemark.noteContent}</h5>
				<c:if test="${activityRemark.editFlag=='0'}">
					<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"> <fmt:formatDate value="${activityRemark.createTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate> 由${activityRemark.createBy}创建</small>
				</c:if>
				<c:if test="${activityRemark.editFlag=='1'}">
					<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"> <fmt:formatDate value="${activityRemark.editTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate> 由${activityRemark.editBy}修改</small>
				</c:if>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" name="editA" activityRemarkId="${activityRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" name="deleteA" activityRemarkId="${activityRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		</c:forEach>

		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveCreateActivityRemark">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>
