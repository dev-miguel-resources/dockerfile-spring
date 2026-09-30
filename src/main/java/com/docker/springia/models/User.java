package com.docker.springia.models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity(name = "users")
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column()
    private String name;

    @Column()
    private String email;

    @Column()
    private String password;

    // normal: User user = new User("Miguel", "ing@gmail.com", "1234")
    // builder: User u1 = User.builder()
    // .name("Miguel")
    // .password("1234")
    // .email("miguel@test.com")
    // .build();

}
