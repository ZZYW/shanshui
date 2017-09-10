﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Obi;

public class FirstPersonLauncher : MonoBehaviour {

	public ObiColliderGroup colliderGroup;
	public GameObject prefab;
	public float power = 2;

	
	// Update is called once per frame
	void Update () {

		if ( Input.GetMouseButtonDown(0)){
			RaycastHit hit;
			Ray ray = Camera.main.ScreenPointToRay (Input.mousePosition);

			GameObject projectile = GameObject.Instantiate(prefab,ray.origin,Quaternion.identity);
			Rigidbody rb = projectile.GetComponent<Rigidbody>();
			Collider c = projectile.GetComponent<Collider>();

			if (rb != null){
				rb.velocity = ray.direction * power;
			}

			if (colliderGroup != null && c != null){
				colliderGroup.AddCollider(c);
			}

		}
	}
}
