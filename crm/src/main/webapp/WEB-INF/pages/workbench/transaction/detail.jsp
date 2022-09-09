<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
<meta charset="UTF-8">

<link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<style type="text/css">
.mystage{
	font-size: 20px;
	vertical-align: middle;
	cursor: pointer;
}
.closingDate{
	font-size : 15px;
	cursor: pointer;
	vertical-align: middle;
}
</style>

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

		$("#transactionRemarkListDiv").on("mouseover", ".remarkDiv", function (){
			$(this).children("div").children("div").show();
		});
		$("#transactionRemarkListDiv").on("mouseout", ".remarkDiv", function (){
			$(this).children("div").children("div").hide();
		});
		// $(".remarkDiv").mouseover(function(){
		// 	$(this).children("div").children("div").show();
		// });
		//
		// $(".remarkDiv").mouseout(function(){
		// 	$(this).children("div").children("div").hide();
		// });
		$("#transactionRemarkListDiv").on("mouseover", ".myHref", function (){
			$(this).children("span").css("color","red");
		});
		$("#transactionRemarkListDiv").on("mouseout", ".myHref", function (){
			$(this).children("span").css("color","#E6E6E6");
		});
		// $(".myHref").mouseover(function(){
		// 	$(this).children("span").css("color","red");
		// });
		//
		// $(".myHref").mouseout(function(){
		// 	$(this).children("span").css("color","#E6E6E6");
		// });


		//阶段提示框
		$(".mystage").popover({
            trigger:'manual',
            placement : 'bottom',
            html: 'true',
            animation: false
        }).on("mouseenter", function () {
                    var _this = this;
                    $(this).popover("show");
                    $(this).siblings(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                    });
                }).on("mouseleave", function () {
                    var _this = this;
                    setTimeout(function () {
                        if (!$(".popover:hover").length) {
                            $(_this).popover("hide")
                        }
                    }, 100);
                });

		$("#saveCreateTransactionRemarkBtn").click(function (){
			var noteContent = $.trim($("#remark").val());
			var tranId = '${transaction.id}';
			if(noteContent == ""){
				alert("请输入备注内容！");
				return;
			}
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/transaction/saveCreateTransactionRemark',
				data:{noteContent:noteContent, tranId:tranId},
				type:'post',
				dataType:'json',
				success:function (returnObj){
					if(returnObj.flag=="1"){
						$("#remark").val("");
						var htmlStr = "";
						htmlStr+="<div class=\"remarkDiv\" id=\"div_"+returnObj.returnData.id+"\" style=\"height: 60px;\">";
						htmlStr+="<img title=\"${sessionScope.sessionUser.name}\" src=\"${pageContext.request.contextPath}/image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
						htmlStr+="<div style=\"position: relative; top: -40px; left: 40px;\" >";
						htmlStr+="<h5>"+returnObj.returnData.noteContent+"</h5>";
						htmlStr+="<font color=\"gray\">交易</font> <font color=\"gray\">-</font> <b>${transaction.name}</b> <small style=\"color: gray;\"> "+returnObj.returnData.createTime+" 由${sessionScope.sessionUser.name}创建</small>";
						htmlStr+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
						htmlStr+="<a class=\"myHref\" name=\"editA\" transactionRemarkId=\""+returnObj.returnData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						htmlStr+="&nbsp;&nbsp;&nbsp;&nbsp;";
						htmlStr+="<a class=\"myHref\" name=\"deleteA\" transactionRemarkId=\""+returnObj.returnData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						htmlStr+="</div>";
						htmlStr+="</div>";
						htmlStr+="</div>";
						$("#transactionRemark").after(htmlStr);
					}else {
						alert(returnObj.message);
					}
				}
			});
		});

		$("#transactionRemarkListDiv").on("click", "a[name='deleteA']", function (){
			var id = $(this).attr("transactionRemarkId");
			$.ajax({
				url:'${pageContext.request.contextPath}/workbench/transaction/deleteTransactionRemarkById',
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

		$("#transactionRemarkListDiv").on("click", "a[name='editA']", function (){
			var id = $(this).attr("transactionRemarkId");
			var noteContent = $("#div_"+id+" h5").text();
			$("#edit-id").val(id);
			$("#edit-noteContent").val(noteContent);
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
				url:'${pageContext.request.contextPath}/workbench/transaction/saveEditTransactionRemark',
				data:{id:id, noteContent:noteContent},
				type:'post',
				dataType:'json',
				success:function (returnObj){
					if(returnObj.flag=="1"){
						$("#editRemarkModal").modal("hide");
						$("#div_"+id+" h5").text(returnObj.returnData.noteContent);
						$("#div_"+id+" small").text(" "+returnObj.returnData.editTime+" 由${sessionScope.sessionUser.name}修改");
					}else {
						alert(returnObj.message);
					}
				}
			});
		});
	});



</script>

</head>
<body>
	<!-- 修改交易备注的模态窗口 -->
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
			<h3>${transaction.name} <small>￥${transaction.money}</small></h3>
		</div>

	</div>

	<br/>
	<br/>
	<br/>

	<!-- 阶段状态 -->
	<div style="position: relative; left: 40px; top: -50px;">
		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<c:forEach items="${stageList}" var="stage">
			<c:if test="${transaction.stage==stage.value}">
				<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="${stage.value}" style="color: #90F790;"></span>
				-----------
			</c:if>
			<c:if test="${transaction.orderNo>stage.orderNo}">
				<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="${stage.value}" style="color: #90F790;"></span>
				-----------
			</c:if>
			<c:if test="${transaction.orderNo<stage.orderNo}">
				<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="${stage.value}"></span>
				-----------
			</c:if>
		</c:forEach>
		<span class="closingDate"><fmt:formatDate value="${transaction.expectedDate}" pattern="yyyy-MM-dd"></fmt:formatDate></span>
	</div>

	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${transaction.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${transaction.money}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${transaction.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b><fmt:formatDate value="${transaction.expectedDate}" pattern="yyyy-MM-dd"></fmt:formatDate></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${transaction.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${transaction.stage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${transaction.type}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${transaction.possibility}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${transaction.source}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${transaction.activityId}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${transaction.contactsId}</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${transaction.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;"><fmt:formatDate value="${transaction.createTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate></small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${transaction.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;"><fmt:formatDate value="${transaction.editTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate></small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${transaction.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${transaction.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b><fmt:formatDate value="${transaction.nextContactTime}" pattern="yyyy-MM-dd"></fmt:formatDate></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>

	<!-- 备注 -->
	<div id="transactionRemarkListDiv" style="position: relative; top: 100px; left: 40px;">
		<div class="page-header" id="transactionRemark">
			<h4>备注</h4>
		</div>

		<c:forEach items="${transactionRemarkList}" var="transactionRemark">
			<div class="remarkDiv" id="div_${transactionRemark.id}" style="height: 60px;">
			<img title="${transactionRemark.createBy}" src="${pageContext.request.contextPath}/image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>${transactionRemark.noteContent}</h5>
				<c:if test="${transactionRemark.editFlag=='0'}">
					<font color="gray">交易</font> <font color="gray">-</font> <b>${transaction.name}</b> <small style="color: gray;"> <fmt:formatDate value="${transactionRemark.createTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate> 由${transactionRemark.createBy}创建</small>
				</c:if>
				<c:if test="${transactionRemark.editFlag=='1'}">
					<font color="gray">交易</font> <font color="gray">-</font> <b>${transaction.name}</b> <small style="color: gray;"> <fmt:formatDate value="${transactionRemark.editTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate> 由${transactionRemark.editBy}修改</small>
				</c:if>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" name="editA" transactionRemarkId="${transactionRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" name="deleteA" transactionRemarkId="${transactionRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		</c:forEach>

		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveCreateTransactionRemarkBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>

	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>预计成交日期</td>
							<td>创建时间</td>
							<td>创建人</td>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${transactionHistoryList}" var="transactionHistory">
						<tr>
							<td>${transactionHistory.stage}</td>
							<td>${transactionHistory.money}</td>
							<td><fmt:formatDate value="${transactionHistory.expectedDate}" pattern="yyyy-MM-dd"></fmt:formatDate></td>
							<td><fmt:formatDate value="${transactionHistory.createTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate></td>
							<td>${transactionHistory.createBy}</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
			</div>

		</div>
	</div>

	<div style="height: 200px;"></div>

</body>
</html>
