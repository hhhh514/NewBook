import { createRouter, createWebHistory } from 'vue-router';
import AuthPage from './pages/AuthPage.vue';
import PostsPage from './pages/PostsPage.vue';
import ProfilePage from './pages/ProfilePage.vue';

export default createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', redirect: '/posts' },
    { path: '/auth', component: AuthPage },
    { path: '/posts', component: PostsPage },
    { path: '/profile/:id', component: ProfilePage },
  ],
});
