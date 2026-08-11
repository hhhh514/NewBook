<script setup>
import { onMounted, ref } from 'vue';
import { RouterLink, useRouter } from 'vue-router';
import { api, me } from '../auth';

const router = useRouter();
const posts = ref([]);
const notice = ref('');
const draft = ref({ content: '', image: '' });
const editing = ref(null);
const commenting = ref(null);
const commentDraft = ref('');

async function load() {
  try {
    posts.value = await api('/api/posts');
  } catch (error) {
    notice.value = error.message;
  }
}

function loginRequired() {
  if (!me.userId) {
    notice.value = '請先登入';
    router.push('/auth');
    return false;
  }
  return true;
}

async function submit() {
  if (!loginRequired()) return;

  try {
    if (editing.value) {
      await api(`/api/posts/${editing.value}`, {
        method: 'PUT',
        body: JSON.stringify(draft.value),
      });
    } else {
      await api('/api/posts', { method: 'POST', body: JSON.stringify(draft.value) });
    }
    draft.value = { content: '', image: '' };
    editing.value = null;
    await load();
  } catch (error) {
    notice.value = error.message;
  }
}

function edit(post) {
  editing.value = post.postId;
  draft.value = { content: post.content, image: post.image || '' };
}

async function remove(id) {
  if (!confirm('確定刪除這篇文章？')) return;
  try {
    await api(`/api/posts/${id}`, { method: 'DELETE' });
    await load();
  } catch (error) {
    notice.value = error.message;
  }
}

function openComment(post) {
  if (!loginRequired()) return;
  commenting.value = post.postId;
  commentDraft.value = '';
}

async function comment(post) {
  if (!commentDraft.value.trim()) return;
  try {
    await api(`/api/posts/${post.postId}/comments`, {
      method: 'POST',
      body: JSON.stringify({ content: commentDraft.value }),
    });
    commenting.value = null;
    commentDraft.value = '';
    await load();
  } catch (error) {
    notice.value = error.message;
  }
}

onMounted(load);
</script>

<template>
  <p v-if="notice" class="notice">{{ notice }}</p>

  <section v-if="me.userId" class="card">
    <h2>{{ editing ? '編輯文章' : '發佈文章' }}</h2>
    <textarea v-model="draft.content" maxlength="5000" placeholder="分享你的想法..." required />
    <input v-model="draft.image" placeholder="圖片 URL（選填）">
    <button @click="submit">{{ editing ? '儲存' : '發佈' }}</button>
    <button v-if="editing" @click="editing = null; draft = { content: '', image: '' }">取消</button>
  </section>

  <section v-else class="card">
    <p>登入後即可發文與留言。</p>
    <button @click="router.push('/auth')">前往登入</button>
  </section>

  <article v-for="post in posts" :key="post.postId" class="card">
    <div class="meta">
      <RouterLink :to="`/profile/${post.userId}`">{{ post.userName }}</RouterLink>
      · {{ new Date(post.createdAt).toLocaleString() }}
    </div>
    <p>{{ post.content }}</p>
    <img v-if="post.image" :src="post.image" alt="文章圖片">
    <div>
      <button @click="openComment(post)">留言</button>
      <template v-if="me.userId === post.userId">
        <button @click="edit(post)">編輯</button>
        <button @click="remove(post.postId)">刪除</button>
      </template>
    </div>

    <form v-if="commenting === post.postId" class="comment-form" @submit.prevent="comment(post)">
      <textarea v-model="commentDraft" maxlength="2000" placeholder="寫下留言..." required />
      <button>送出留言</button>
      <button type="button" @click="commenting = null">取消</button>
    </form>

    <div class="comments">
      <p v-for="comment in post.comments" :key="comment.commentId">
        <b>{{ comment.userName }}</b>：{{ comment.content }}
      </p>
    </div>
  </article>
</template>
