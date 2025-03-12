<template>
  <div class="inventory-table">
    <div class="controls mb-4">
      <button @click="showAddModal = true" class="btn-primary">Add New Item</button>
    </div>

    <table class="w-full">
      <thead>
        <tr>
          <th>SKU</th>
          <th>Name</th>
          <th>Description</th>
          <th>Price</th>
          <th>Quantity</th>
          <th>Category</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in items" :key="item.id">
          <td>{{ item.sku }}</td>
          <td>{{ item.name }}</td>
          <td>{{ item.description }}</td>
          <td>${{ item.price }}</td>
          <td>{{ item.quantity }}</td>
          <td>{{ item.category }}</td>
          <td>
            <button @click="editItem(item)" class="btn-secondary mr-2">Edit</button>
            <button @click="deleteItem(item.id)" class="btn-danger">Delete</button>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Add/Edit Modal -->
    <div v-if="showAddModal || showEditModal" class="modal">
      <div class="modal-content">
        <h2>{{ showEditModal ? 'Edit' : 'Add' }} Item</h2>
        <form @submit.prevent="handleSubmit">
          <div class="form-group">
            <label>SKU</label>
            <input v-model="currentItem.sku" required />
          </div>
          <div class="form-group">
            <label>Name</label>
            <input v-model="currentItem.name" required />
          </div>
          <div class="form-group">
            <label>Description</label>
            <textarea v-model="currentItem.description"></textarea>
          </div>
          <div class="form-group">
            <label>Price</label>
            <input type="number" step="0.01" v-model="currentItem.price" required />
          </div>
          <div class="form-group">
            <label>Quantity</label>
            <input type="number" v-model="currentItem.quantity" required />
          </div>
          <div class="form-group">
            <label>Category</label>
            <input v-model="currentItem.category" required />
          </div>
          <div class="modal-actions">
            <button type="submit" class="btn-primary">Save</button>
            <button type="button" @click="closeModal" class="btn-secondary">Cancel</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import { getApiUrl } from '../config';

export default {
  name: 'InventoryTable',
  data() {
    return {
      items: [],
      showAddModal: false,
      showEditModal: false,
      currentItem: {
        sku: '',
        name: '',
        description: '',
        price: 0,
        quantity: 0,
        category: ''
      }
    };
  },
  async created() {
    await this.fetchItems();
  },
  methods: {
    async fetchItems() {
      try {
        const response = await axios.get(getApiUrl('inventory'));
        this.items = response.data;
      } catch (error) {
        console.error('Error fetching items:', error);
      }
    },
    editItem(item) {
      this.currentItem = { ...item };
      this.showEditModal = true;
    },
    async deleteItem(id) {
      if (confirm('Are you sure you want to delete this item?')) {
        try {
          await axios.delete(getApiUrl(`inventory/${id}`));
          await this.fetchItems();
        } catch (error) {
          console.error('Error deleting item:', error);
        }
      }
    },
    async handleSubmit() {
      try {
        if (this.showEditModal) {
          await axios.put(getApiUrl(`inventory/${this.currentItem.id}`), this.currentItem);
        } else {
          await axios.post(getApiUrl('inventory'), this.currentItem);
        }
        await this.fetchItems();
        this.closeModal();
      } catch (error) {
        console.error('Error saving item:', error);
      }
    },
    closeModal() {
      this.showAddModal = false;
      this.showEditModal = false;
      this.currentItem = {
        sku: '',
        name: '',
        description: '',
        price: 0,
        quantity: 0,
        category: ''
      };
    }
  }
};
</script>

<style scoped>
.inventory-table {
  padding: 20px;
}

table {
  border-collapse: collapse;
  width: 100%;
  background-color: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

th, td {
  border: 1px solid #ddd;
  padding: 12px;
  text-align: left;
  color: #333;
}

th {
  background-color: #f4f4f4;
  font-weight: 600;
  text-transform: uppercase;
  font-size: 0.9em;
}

tr:hover {
  background-color: #f8f9fa;
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
}

.modal-content {
  background: white;
  padding: 20px;
  border-radius: 8px;
  width: 500px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.modal-content h2 {
  color: #333;
  margin-bottom: 20px;
}

.form-group label {
  color: #333;
  font-weight: 500;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  background-color: white;
  color: #333;
}

.btn-primary {
  background: #4CAF50;
  color: white;
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.btn-secondary {
  background: #2196F3;
  color: white;
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.btn-danger {
  background: #f44336;
  color: white;
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.modal-actions {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}
</style>
