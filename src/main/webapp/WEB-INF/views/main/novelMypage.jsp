<%@page import="java.util.Set"%>
<%@page import="com.novelstory.model.EpisodeTO"%>
<%@page import="com.novelstory.model.NovelListTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%	
	ArrayList<NovelListTO> novelInfo = (ArrayList) request.getAttribute("novelInfo");

	
	// 로그인한 회원의 id session
	String idSession = (String)session.getAttribute("logId");
	Integer myPoint = (Integer)session.getAttribute("point");
	
	StringBuilder sbHtml = new StringBuilder();
	
	for(NovelListTO nvTO : novelInfo) {
	
		sbHtml.append("<div class='card'>");
	    sbHtml.append("<a href='novelView.do?nvId="+ nvTO.getNvId() +"'>");
	    sbHtml.append("<img src='" + nvTO.getImageurl() + "' class='card-img-top' alt='...'>");
	    sbHtml.append("</a>"); 
	    sbHtml.append("<div class='card-body'>" + nvTO.getNvtitle() + "</div>");
	    sbHtml.append("<div class='card-body'>" + nvTO.getNvwriter() + "</div>"); 
	    sbHtml.append("</div>");

	}

%>
<html>
<head>
<meta charset="UTF-8">
<title><%=idSession %>님의 페이지 - Novel Story</title>
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
	        <li><a id="dailyGacha">일일 무료 뽑기</a></li>
	        <li><a href="novelstorypayments.do">포인트 구매</a></li>
			<li><a href="novelMypage.do"> <%=idSession %>의 페이지</a></li>
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

<div class="mypageLabel"><%=idSession %>님의 소장 중인 소설 목록</div>
<div class="card-container">
	<%=sbHtml %>
</div>



<!-- 모달 관련 스크립 -->
<script src="./assets/js/log.js"></script>
<script src="./assets/js/gacha.js"></script>


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