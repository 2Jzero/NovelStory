<%@page import="java.util.Set"%>
<%@page import="com.novelstory.model.EpisodeTO"%>
<%@page import="com.novelstory.model.NovelListTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%	
	NovelListTO nvTO = (NovelListTO) request.getAttribute("nvTO");
	EpisodeTO epTO = (EpisodeTO) request.getAttribute("epTO");
	// 소설의 마지막화를 나타내는 변수
	int epNumMax = (Integer) request.getAttribute("epNumMax");
	
	// 로그인한 회원의 id session
	String idSession = (String)session.getAttribute("logId");
	Integer myPoint = (Integer)session.getAttribute("point");
	
	// 이전화, 다음화 설정에 필요한 변수
	String nvId = nvTO.getNvId();
	int epNum = epTO.getEP_NUM();
	
	StringBuilder sbHtml = new StringBuilder();
	
	sbHtml.append("<div>" + epTO.getEP_CONTENT() + "</div>");


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

<div class="container">
	<%=sbHtml %>
</div>

<div class="button-container">
    <button class="backward" id="backward" title="이전화"><i class="fa-solid fa-backward"></i></button>
    <button class="forward" id="forward" title="다음화"><i class="fa-solid fa-forward"></i></button>
</div>


<script>
	$(document).ready(function() {
		
		let nvId = <%=nvId %>
		let epNum = <%=epNum %>
		let epNumMax = <%=epNumMax %>
		// 자바 변수를 자바스크립트의 문자열로 인식하도록 ""로 문자열로 만들어 안전하게 전달
		const idSession = "<%=idSession %>";
		
		// 이전화로 이동
        $("#backward").click(function() {
        	// 처음화일 경우 경고창
        	if(epNum == 1) {
        		 Swal.fire({
        		        title: '알림',
        		        text: '작품의 첫 화입니다.!',
        		        icon: 'error',
        		        confirmButtonText: '확인'
        		});
        	} else {
        		$.ajax({
					url: "epBackward.do",
					type: "GET",
					data: {
						nvId: nvId,
						epNum: epNum					
					},
					success: function(response) {				
			            // 서버에서 반환된 JSON 객체
			            let episode = response.EPISODE;
			            let nextEpNum = response.EP_NUM;
			            let nextIsPurchased = response.IS_PURCHASED;

			        	// 4화부터 유료분이므로, 그에 따른 확인창 생성		        	
						// 가끔 4화를 구매해야하는데 5화를 구매하는 경우 이전화를 누를때 그냥 넘어가는것을 방지하기위해 이 조건문을 걸어줌
						// 이렇게 하면 이전화 버튼을 누를시에 무료화여도 알림창이 뜨는 경우가 있어 이를 방지하기 위해 무료도 확인
						if (nextEpNum > 3 && !nextIsPurchased.includes(idSession)) {
			        		Swal.fire({
			        	        title: '알림',
			        	        text: '유료화입니다. 소장하시겠습니까? (100P 소모)',
			                    icon: 'warning',
			                    showCancelButton: true,
			                    confirmButtonText: '확인',
			                    cancelButtonText: '취소'
			        	    }).then((result) => {
			        	    	if(result.isConfirmed) {
			        	    		Swal.fire({
			        					title: "구매 중...",
			        					showConfirmButton: false, // OK 버튼을 숨김
			        					timer: 1000
			        				}).then(function() {				        	    	
					        			window.location.href = 'viewEpisode.do?nvId=' + nvId + '&episode=' + episode; // 페이지 리다이렉트
					        	    	});
					        	    };
			        	    	});
			        	}
			        	else {
						window.location.href = 'viewEpisode.do?nvId=' + nvId + '&episode=' + episode; // 페이지 리다이렉트
			        	}
					},
					error: function(error) {
						// 오류 처리
						console.error("Error: " + error);
					}
				});
			}
		});
		
		// 다음화로 이동
        $("#forward").click(function() {			
        	// 처음화일 경우 경고창
        	if(epNum == epNumMax) {
        		 Swal.fire({
        		        title: '알림',
        		        text: '작품의 마지막 화입니다.!',
        		        icon: 'error',
        		        confirmButtonText: '확인'
        		});
        	} else {
        		$.ajax({
					url: "epForward.do",
					type: "GET",
					data: {
						nvId: nvId,
						epNum: epNum					
					},
					success: function(response) {				
			            // 서버에서 반환된 JSON 객체
			            let episode = response.EPISODE;
			            let nextEpNum = response.EP_NUM;
			            let nextIsPurchased = response.IS_PURCHASED;	
	
			        	// 4화부터 유료분이므로, 그에 따른 확인창 생성		        	
						if (nextEpNum > 3 && !nextIsPurchased.includes(idSession)) {
			        		Swal.fire({
			        	        title: '알림',
			        	        text: '유료화입니다. 소장하시겠습니까? (100P 소모)',
			                    icon: 'warning',
			                    showCancelButton: true,
			                    confirmButtonText: '확인',
			                    cancelButtonText: '취소'
			        	    }).then((result) => {
			        	    	if(result.isConfirmed) {
			        	    		Swal.fire({
			        					title: "구매 중...",
			        					showConfirmButton: false, // OK 버튼을 숨김
			        					timer: 1000
			        				}).then(function() {				        	    	
					        			window.location.href = 'viewEpisode.do?nvId=' + nvId + '&episode=' + episode; // 페이지 리다이렉트
					        	    	});
					        	    };
			        	    	});
			        	}
			        	else {
						window.location.href = 'viewEpisode.do?nvId=' + nvId + '&episode=' + episode; // 페이지 리다이렉트
			        	}
					},
					error: function(error) {
						// 오류 처리
						console.error("Error: " + error);
					}
				});
        	};
		});
		
	});

</script>

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