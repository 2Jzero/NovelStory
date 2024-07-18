<%@page import="com.novelstory.model.EpisodeTO"%>
<%@page import="com.novelstory.model.NovelListTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%	
	NovelListTO nvTO = (NovelListTO) request.getAttribute("nvTO");
	ArrayList<EpisodeTO> epList = (ArrayList) request.getAttribute("epList");

	// 로그인한 회원의 id session
	String idSession = (String)session.getAttribute("logId");
	Integer myPoint = (Integer)session.getAttribute("point");

	String category = "";
	
	String nvId = "";
	String episode = "";
	String isPurchased = "";
	
	StringBuilder sbHtml = new StringBuilder();
	
	// 필터링
	if(nvTO.getCategory().equals("Fantasy")) {
		category = "판타지";
	} else if(nvTO.getCategory().equals("RoFantasy")) {
		category = "로판";
	}
	
	for(EpisodeTO epTO : epList) {
		
		nvId = nvTO.getNvId();
		episode = epTO.getEPISODE();
		isPurchased = epTO.getIS_PURCHASED();
		
		sbHtml.append("<a>" + nvTO.getNvtitle() + " " + epTO.getEP_NUM() + "화 </a>");
		if(epTO.getEP_NUM() < 4) {
			
			sbHtml.append("<a href='viewEpisode.do?nvId=" + nvId + "&episode=" + episode + "'name='free'> 무료 보기 </a>");
			
		} else {
			if(isPurchased.equals("X")) {
				
	            sbHtml.append("<a href='#' onclick='return confirmPurchase(\"" + nvId + "\", \"" + episode + "\");'> 100P </a>");

			} else if(isPurchased.equals("소장")) {
				
				sbHtml.append("<a href='viewEpisode.do?nvId=" + nvId + "&episode=" + episode + "'name='free'> 소장됨 </a>");

			}
		}
		sbHtml.append("<br>");
	}
	
	sbHtml.append("<script>");
	sbHtml.append("function confirmPurchase(nvId, episode) {");
	sbHtml.append("    if (confirm('100P를 사용하여 이 에피소드를 구매하시겠습니까?')) {");  // 이 if문 위에다 넣어보기 내일 ㅇㅇ
	sbHtml.append("        window.location.href = 'viewEpisode.do?nvId=' + nvId + '&episode=' + episode;");
	sbHtml.append("    }");
	sbHtml.append("}");
	sbHtml.append("</script>");
	

%>
<html>
<head>
<meta charset="UTF-8">
<title><%=nvTO.getNvtitle() %> - Novel Story</title>
<!-- main화면 디자인 CSS -->
<link rel="stylesheet" href="assets/css/main.css"/>
<link rel="stylesheet" href="assets/css/view.css"/>

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
<form action="novelStoryLogin.do" method="post">
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
</form>
    
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


<div class="container">
	<div class="vCard">
		<img src= "<%=nvTO.getImageurl() %>" class="card-img">
		<div class="vCard-body"><%=nvTO.getNvtitle() %></div>
		<div class="vCard-body" style="font-size: 17px;">작가 : <%=nvTO.getNvwriter() %></div>
		<div class="vCard-body" style="font-size: 17px;">장르 : <%=category %></div>
	</div>
	<div class="novel-list">
		<%=sbHtml %>	
	</div>
</div>


<div class="footer">
<div class="fCard">
	작가의 다른 작품 :
</div>
</div>

<!-- 모달 관련 스크립 -->
<script src="./assets/js/logout.js"></script>
<script src="./assets/js/modal.js"></script>
<script src="./assets/js/birthday.js"></script>
<script src="./assets/js/ajax.js"></script>

	
</body>
</html>