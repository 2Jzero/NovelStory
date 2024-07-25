<%@page import="java.util.HashSet"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Set"%>
<%@page import="com.novelstory.model.EpisodeTO"%>
<%@page import="com.novelstory.model.NovelListTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%	
	// nvId를 위한 변수
	NovelListTO nvTO = (NovelListTO) request.getAttribute("nvTO");
	// 소설의 회차 리스트
	ArrayList<EpisodeTO> epList = (ArrayList) request.getAttribute("epList");
	// 작가의 다른 작품 리스트
	ArrayList<NovelListTO> otherList = (ArrayList) request.getAttribute("otherList");

	// 로그인한 회원의 id session , point
	String idSession = (String)session.getAttribute("logId");
	Integer myPoint = (Integer)session.getAttribute("point");

	String category = "";
	
	String nvId = "";
	String episode = "";
	
	// 회차 리스트 html
	StringBuilder epHtml = new StringBuilder();
	
	StringBuilder otherHtml = new StringBuilder();
	
	System.out.println(idSession);
	
	// 필터링
	if(nvTO.getCategory().equals("Fantasy")) {
		category = "판타지";
	} else if(nvTO.getCategory().equals("RoFantasy")) {
		category = "로판";
	} else if(nvTO.getCategory().equals("RealFantasy")) {
		category = "현판";
	} else if(nvTO.getCategory().equals("Romance")) {
		category = "로맨스";
	} else if(nvTO.getCategory().equals("Wuxia")) {
		category = "무협";
	} else if(nvTO.getCategory().equals("Drama")) {
		category = "드라마";
	}
	
	// 회차 리스트 띄우기
	for(EpisodeTO epTO : epList) {
		
		nvId = nvTO.getNvId();
		episode = epTO.getEPISODE();
	    // 중복을 고려하여 Set 사용하고 세션 배열을 리스트로 변환한 후 저장
    	Set<String> purchasedIdsSet = new HashSet<>(Arrays.asList(epTO.getIS_PURCHASED().split("/")));
	    
		epHtml.append("<a>" + nvTO.getNvtitle() + " " + epTO.getEP_NUM() + "화 </a>");
		if(epTO.getEP_NUM() < 4) {	
			epHtml.append("<a href='viewEpisode.do?nvId=" + nvId + "&episode=" + episode + "'name='free'> 무료 보기 </a>");			
		} else {
			if(!purchasedIdsSet.contains(idSession)) { // 현재 세션 아이디값으로 소설을 구매했는지 확인
	            epHtml.append("<a href='#' onclick='return confirmPurchase(\"" + nvId + "\", \"" + episode + "\");'> 100P </a>");
			} else if(purchasedIdsSet.contains(idSession)) {				
				epHtml.append("<a href='viewEpisode.do?nvId=" + nvId + "&episode=" + episode + "'name='free'> 소장됨 </a>");
			}
		}
		epHtml.append("<br>");
	}
	
	// 확인창 -> 확인을 누르면 100원 차감되고 페이지 이동
	epHtml.append("<script>");
	epHtml.append("function confirmPurchase(nvId, episode) {");
	epHtml.append("    if (confirm('100P를 사용하여 이 에피소드를 구매하시겠습니까?')) {");  // 이 if문 위에다 넣어보기 내일 ㅇㅇ
	epHtml.append("        window.location.href = 'viewEpisode.do?nvId=' + nvId + '&episode=' + episode;");
	epHtml.append("    }");
	epHtml.append("}");
	epHtml.append("</script>");
	
	
	// 작가의 다른 작품 리스트
	for(NovelListTO other : otherList) {
		
		if(!nvTO.getNvtitle().equals(other.getNvtitle())) {
	    otherHtml.append("<div class='fCard'>");
	    otherHtml.append("<a href='novelView.do?nvId="+ other.getNvId() +"'>");
	    otherHtml.append("<img src='" + other.getImageurl() + "' class='fCard-img' alt='...'>");
	    otherHtml.append("</a>"); 
	    otherHtml.append("<div class='fCard-body'>" + other.getNvtitle() + "</div>");
	    otherHtml.append("</div>");
		}

	}

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

<div class="container">
	<div class="vCard">
		<img src= "<%=nvTO.getImageurl() %>" class="card-img">
		<div class="vCard-body"><%=nvTO.getNvtitle() %></div>
		<div class="vCard-body" style="font-size: 17px;">작가 : <%=nvTO.getNvwriter() %></div>
		<div class="vCard-body" style="font-size: 17px;">장르 : <%=category %></div>
	</div>
	<div class="novel-list">
		<%=epHtml %>	
	</div>
</div>


<div class="otherLayer">작가의 다른 작품</div> 
<div class="container2">
	<%=otherHtml %>
</div>

<!-- 모달 관련 스크립 -->
<script src="./assets/js/log.js"></script>

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