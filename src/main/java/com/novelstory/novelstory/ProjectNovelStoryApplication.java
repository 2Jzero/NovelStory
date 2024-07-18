package com.novelstory.novelstory;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages = { "com.novelstory.controller", "com.novelstory.mapper", "com.novelstory.service", "com.novelstory.model" } )
@MapperScan("com.novelstory.mapper")

public class ProjectNovelStoryApplication {

	public static void main(String[] args) {
		SpringApplication.run(ProjectNovelStoryApplication.class, args);
	}

}
