<%@page import="com.novelstory.model.NovelListTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%

String idSession = (String)session.getAttribute("logId");
Integer myPoint = (Integer)session.getAttribute("point");


%>
<html>
<head>
<meta charset="UTF-8">
<title>Novel Story : 코인 결제</title>

<!-- main화면 디자인 CSS -->
<link rel="stylesheet" href="assets/css/main.css"/>
<!-- modal화면 디자인 CSS -->
<link rel="stylesheet" href="assets/css/modal.css"/>

<!-- 부트스트랩 CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">

<!-- 아이콘 CDN -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">

<!-- 토스페이먼츠 결제창 SDK 추가 -->
<script src="https://js.tosspayments.com/v1/payment-widget"></script>

<!-- sweetAlert -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>

</style>
</head>
<body>
<!--  세션을 이용하여 로그인하지 않으면 못들어가게 차단 -->
<% if(idSession != null) { %>
<!-- 메뉴바 -->
<nav id="nav3" style="display: flex; justify-content: space-between; align-items: center;">
    <div>
        <a href="novelStory.do"><img src="./assets/images/NSLogo.png"></a>
    </div>
    <div>
	    <ul class="navbar-nav mr-auto">
	        <li>
	            <form id="sfrm" action="novelStory.do" method="POST">
	                <input type="text" name="searchWord" placeholder="제목을 입력하세요">
				    <button type="submit"><i class="fas fa-search"></i></button>
	            </form>
	        </li>
	        <li><a href="novelstorypayments.do">토큰 구매</a></li>
			<li><a id="mypage"> <%=idSession %>의 페이지</a></li>
		    <li><a><i class="fa-solid fa-coins" style="color:yellow"></i> <%=myPoint %>P</a></li>
			<li><a id="logout">로그아웃</a></li>
	    </ul>
	</div>
</nav>

<!-- 로그인 모달 부분 -->
<div id="logModal" class="modal">
	<div class="modal-content">
	    <div class="modal-header">
            <span class="headLine">로그인</span>
            <span class="close">&times;</span>
        </div>
	    아이디 <input type="text" id="loginId" name="loginId" />
	    비밀번호 <input type="password" id="loginPw" name="loginPw" />
	    <button type="submit" class="btn btn-info" id="login">로그인</button>
	    <a id="signModal">회원가입</a>
	</div>
</div>

<div class="card-container2">
	<div class="card2">
		코인 1개 : 100원 <button class="btn btn-outline-primary" data-amount="100">결제하기</button><br><br>
		코인 11개 : 1000원 <button class="btn btn-outline-primary" data-amount="1000">결제하기</button><br><br>
		코인 110개 : 10000원 <button class="btn btn-outline-primary" data-amount="10000">결제하기</button><br><br>
		코인 360개 : 30000원 <button class="btn btn-outline-primary" data-amount="10000">결제하기</button><br><br><br>
		
		<div style="color:coral">한달마다 결제시 기간 내 소설 무한 보기 가능!</div>
		매달 월정액 : 9900원  <button class="btn btn-outline-primary" data-amount="10000">결제하기</button><br><br>
	</div>
</div>

<!-- 결제 UI, 이용약관 UI 영역 -->
<div id="myModal" class="modal">
    <div class="modal-content">
        <span class="closeBtn">&times;</span>
        <div id="payment-method">
        </div>
        <div id="agreement">
        </div>
		<!-- 결제하기 버튼 -->
		<button type="button" id="payment-button">결제하기</button>
    </div>
</div>


<!-- 결제 API 모달 및 정보 -->
<script src="./assets/js/log.js"></script>
<script src="./assets/js/tossAPI.js"></script>
<% } else { %>
<script>
window.onload = function() {
    Swal.fire({
        title: '로그인',
        text: '로그인이 필요합니다!',
        icon: 'error',
        confirmButtonText: '확인'
    }).then(function() {
        history.back();
    });
}
</script>
<% } %>	
</body>
</html>