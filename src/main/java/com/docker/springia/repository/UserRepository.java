package com.docker.springia.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.docker.springia.models.User;

public interface UserRepository extends JpaRepository<User, Long> {

}
