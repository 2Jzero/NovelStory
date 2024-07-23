<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	boolean flag = (boolean)request.getAttribute( "flag" );

	out.println( "<script type='text/javascript'>" );
	if( flag == true ) {
		out.println( "alert('로그인 성공');" );
		out.println( "location.href='novelStory.do'" );
	} else {
		out.println( "alert('로그인 실패');" );
		out.println( "history.back();" );
	}
	out.println( "</script>" );
%>
