package fr.univtln.bruno.java.jpa;

import fr.univtln.bruno.java.jpa.entities.Student;

import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityManager;
import javax.persistence.Persistence;

public  class JPAFirstApp {

     public  static  void main(String[] args) {

        EntityManagerFactory emf = Persistence.createEntityManagerFactory("test-pg-docker") ;

        EntityManager em = emf.createEntityManager() ;

        Student student1 =  new Student() ;
        em.getTransaction().begin() ;
        em.persist(student1) ;
        em.getTransaction().commit() ;

        System.out.println("Id = " + student1.getId()) ;
    }
}