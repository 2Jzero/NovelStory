package com.novelstory.mapper;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.novelstory.model.EpisodeTO;
import com.novelstory.model.NovelListTO;

@Mapper
public interface NovelListMapperInter {

	/* 소설 리스트 크롤링 */
	int novelCrawling(NovelListTO to);
	
	/* 전체 소설 리스트 목록 */
	ArrayList<NovelListTO> novelList();
	
	/* 장르에 따른 소설 리스트 목록*/
	ArrayList<NovelListTO> categoryList(String category);
	
	/* 검색한 소설 리스트 */
    ArrayList<NovelListTO> searchNovelList(@Param("searchWord") String searchWord);
    
	/* 선택한 소설의 뷰 리스트 */
	NovelListTO novelView(String nvId);
	
	/* 작가의 다른 작품 리스트 */
	ArrayList<NovelListTO> ohterNovel(String nvwriter);
	
	// 회차 더미 데이터
	//int insertData(EpisodeTO epTO);
	
}
