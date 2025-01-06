<%@page import="com.novelstory.model.UserTO"%>
<%@page import="com.novelstory.model.NovelListTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%

	// 소설 리스트
	ArrayList<NovelListTO> categoryList = (ArrayList) request.getAttribute("categoryList");
	
	StringBuilder sbHtml = new StringBuilder();
	
	
		
	// 로그인한 회원의 id session 과 포인트
	String idSession = (String)session.getAttribute("logId");
	Integer myPoint = (Integer)session.getAttribute("point");
	
	if(categoryList.size() != 0) {
		for(NovelListTO nvTO : categoryList) {
			
	    sbHtml.append("<div class='card'>");
	    sbHtml.append("<a href='novelView.do?nvId="+ nvTO.getNvId() +"'>");
	    sbHtml.append("<img src='" + nvTO.getImageurl() + "' class='card-img-top' alt='...'>");
	    sbHtml.append("</a>"); 
	    sbHtml.append("<div class='card-body'>" + nvTO.getNvtitle() + "</div>");
	    sbHtml.append("<div class='card-body'>" + nvTO.getNvwriter() + "</div>"); 
	    sbHtml.append("</div>");
		
		}
	} else if(categoryList.size() == 0) {
		sbHtml.append("<div class='card-body' style='font-size:20px'>검색 결과가 없습니다.</div>");
	}
	

%>
<html>
<head>
<meta charset="UTF-8">
<title>Novel Story</title>
<!-- main화면 디자인 CSS -->
<link rel="stylesheet" href="assets/css/main.css"/>

<!-- 부트스트랩 CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">

<!-- 아이콘 CDN -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
<!-- jquery -->
<script type="text/javascript" src="assets/js/jquery-3.7.0.js"></script>

<!-- sweetAlert -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>


<style>
</style>
</head>
<body>

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
	        <li><a href="novelstorypayments.do">포인트 구매</a></li>
			<% if (idSession == null) { %>
	        	<li><a id="loginModal">로그인</a></li>
			<% } else { %>
			    <li><a href="novelMypage.do"> <%=idSession %>의 페이지</a></li>
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
     	<a href="https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=dda5b7829285c1bc14a5df7faa52c6df&redirect_uri=http://localhost:8080/novelstory/kakao-login"><img src="./assets/images/kakao_login.png"></a>
	    
	</div>
</div>
    
<!-- 회원가입 모달 부분 -->
<form action="novelStorySign.do" method="post" name="nfrm">
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
	        <button type="button" id="checkBtn" name="checkBtn" disabled>인증확인</button>
	        </div>
	        <button type="submit" class="btn btn-info" id="signOk">회원가입</button>
	  	</div>
  	</div>    
</form>


<!-- 카테고리 -->	
<div class="extranav">웹소설 랭킹</div>
<div class="btn-container">
    <button type="button" class="btn btn-outline-success" name="Fantasy">판타지</button>
    <button type="button" class="btn btn-outline-success" name="RealFantasy">현판</button>
    <button type="button" class="btn btn-outline-success" name="RoFantasy">로판</button>
    <button type="button" class="btn btn-outline-success" name="Romance">로맨스</button>
    <button type="button" class="btn btn-outline-success" name="Wuxia">무협</button>
    <button type="button" class="btn btn-outline-success" name="Drama">드라마</button>
</div>

<div class="card-container">
<%=sbHtml %>
</div>


<!-- js 스크립 -->
<script src="./assets/js/log.js"></script>
<script src="./assets/js/signUp.js"></script>
<script src="./assets/js/modal.js"></script>
<script src="./assets/js/birthday.js"></script>
<script src="./assets/js/categoryAjax.js"></script>

	
</body>
</html>