<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int flag = (int)request.getAttribute( "flag" );

	out.println( "<script type='text/javascript'>" );
	if( flag == 0 ) {
		out.println( "alert('로그인 성공');" );
		out.println( "location.href='novelStory.do'" );
	} else {
		out.println( "alert('로그인 실패');" );
		out.println( "history.back();" );
	}
	out.println( "</script>" );
%>
