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

<style>

</style>
</head>
<body>

<!-- 메뉴바 -->

<nav id="nav3" style="display: flex; justify-content: space-between; align-items: center;">
    <div>
        <a href="main.do"><img src="./assets/images/NSLogo.png"></a>
        <ul>
            <li><a href="main.do">웹소설</a></li>
            <li><a href="novelstorypayments.do">토큰 구매</a></li>
            <li><a href="#">내서재</a></li>
        </ul>
    </div>

    <div>
	    <ul class="navbar-nav mr-auto">
	        <li>
	            <form id="sfrm" action="main.do" method="POST">
	                <input type="text" name="searchWord" placeholder="제목을 입력하세요">
				    <button type="submit"><i class="fas fa-search"></i></button>
	            </form>
	        </li>
			<% if (idSession == null) { %>
	        	<li><a id="loginModal">로그인</a></li>
			<% } else { %>
			    <li><a id="mypage"> <%=idSession %>의 페이지</a></li>
		        <li><a><i class="fa-solid fa-coins" style="color:yellow"></i> <%=myPoint %>P</a></li>
			    <li><a id="logout">로그아웃</a></li>
			<% } %>
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
    
<!-- 회원가입 모달 부분 -->
<form action="novelStorySign.do" method="post">
	<div id="sgModal" class="modal">
	    <div class="modal-content">
	    	<div class="modal-header">
                <span class="headLine">회원가입</span>
                <span class="close">&times;</span>
            </div>
	        아이디 
	        <input type="text" id="signId" name="signId" />
	        비밀번호 
	        <input type="password" id="signPw" name="signPw" />
			<div class="info" id="info__birth">
				<select class="box" id="birth-year" name="birth-year">
			    	<option disabled selected>년</option>
			  </select>
			  <select class="box" id="birth-month" name="birth-month">
			    	<option disabled selected>월</option>
			  </select>
			  <select class="box" id="birth-day" name="birth-day">
			    	<option disabled selected>일</option>
			  </select>
			</div>
	        전화번호
			<div class="phone">	         
	        <input type="text" id="signPhone" name="signPhone" placeholder="-빼고입력" />
	       	<button type="button" id="codeBtn" name="codeBtn">인증번호 발송</button>
	        </div>
			<div class="code">
	        <input type="text" id="signCode" name="signCode" placeholder="인증번호" />
	        <button type="button" id="checkBtn" name="checkBtn">인증확인</button>
	        </div>
	        <button type="submit" class="btn btn-info">회원가입</button>
	  	</div>
  	</div>    
</form>

<div class="card-container2">
	<div class="card2">
		코인 1개 : 100원 <button type="button" class="btn btn-outline-primary" data-amount="100">결제하기</button><br><br>
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
	<script>
        const modal = document.getElementById('myModal');
        const btns = document.querySelectorAll('.btn');
        const closeBtn = document.getElementsByClassName('closeBtn')[0];
        
        //토스 앱키와 결제 정보
        const widgetClientKey = "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm"; // 앱키
        const customerKey = "hlwvhqXVKJa5TsLCRgBq8";  // 고객 고유 id = 나중에 세션 이용하여 담을 것
        const paymentWidget = PaymentWidget(widgetClientKey, customerKey); // 회원 결제
        const paymentMethodsWidget = paymentWidget.renderPaymentMethods(); // 결제 정보 변경

        
        let amount = 0;
        
        // idSession
         let idSession = '<%= session.getAttribute("logId") %>';

        // 클릭한 amount 값 가져오기 위한 이벤트
        btns.forEach(btn => {
            btn.addEventListener('click', function() {
                amount = this.getAttribute('data-amount');
                paymentMethodsWidget.updateAmount(amount); // 변경된 amount 업데이트
                modal.style.display = 'block';

            });
        });

        closeBtn.addEventListener('click', function() {
            modal.style.display = 'none';
        });

        window.addEventListener('click', function(event) {
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        });

		// 토스 정보
        const paymentMethodWidget = paymentWidget.renderPaymentMethods(
            "#payment-method", {
                value : amount
            }, {
                variantKey : "DEFAULT"
            });

        paymentWidget.renderAgreement("#agreement", {
            variantKey : "AGREEMENT"
        });
        
		//결제 요청 응답 처리 : 리퀘스트 파람을 이용해서 안의 결제 정보들을 컨트롤러에서 사용 가능
        document.getElementById("payment-button").addEventListener("click", function() {
            paymentWidget.requestPayment({
            	amount : amount,
                orderId : "13W_pCfO4rzG9szJEcThKe",
                orderName : "노벨 스토리 코인",
                successUrl : "http://localhost:8080/success", // 성공 리다이렉트 URL
                failUrl : "http://localhost:8080/fail", // 실패 리다이렉트 URL
                customerEmail : "customer123@gmail.com",
                customerName : "김토스", // 사용자 정보 다 세션으로 가져와서 바꾸기 ㅇㅇ
                customerMobilePhone : "01012341234",
            }) 
            // 결제창을 띄울수 없는 에러가 발생하면 리다이렉트 URL로 에러를 받을 수 없어요.
            .catch(function (error) {
            	 if (error.code === 'USER_CANCEL') {
            	 	// 결제 취소시 매핑된 fail controller로 이동
            	    window.location.href = 'http://localhost:8080/fail?code=USER_CANCEL&message=' + encodeURIComponent(error.message);
            	} else if (error.code === 'INVALID_ORDER_NAME') {
                  	// 유효하지 않은 'orderName' 처리하기
                } else if (error.code === 'INVALID_ORDER_ID') {
                  	// 유효하지 않은 'orderId' 처리하기
                }
              });
        });
    </script>
</body>
</html>