package com.docker.springia.services;

import java.util.List;

import org.springframework.stereotype.Service;

import com.docker.springia.models.User;
import com.docker.springia.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    public List<User> list() {
        return userRepository.findAll();
    }

    public User getById(Long id) {
        return userRepository.findById(id).orElse(null);
    }

    public User save(User user) {
        return userRepository.save(user);
    }

    public void delete(Long id) {
        userRepository.deleteById(id);
    }

    public User update(Long id, User user) {

        User userExists = userRepository.findById(id).orElse(null);

        if (userExists != null) {

            userExists.setName(user.getName());
            userExists.setEmail(user.getEmail());
            userExists.setPassword(user.getPassword());

            return userRepository.save(userExists);

        }

        return null;
    }

}
